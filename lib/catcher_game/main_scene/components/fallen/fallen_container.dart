import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:bezier/bezier.dart';
import 'package:flame/components.dart';
import 'package:flutter_game_challenge/catcher_game/common/assets_loader.dart';
import 'package:flutter_game_challenge/catcher_game/common/random_generator.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/fallen/recycle_type.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/main_scene.dart';
import 'package:vector_math/vector_math.dart' as vector_math;

class FallenContainer extends PositionComponent with RandomGenerator, HasGameRef<CatcherGame> {
  FallenContainer({
    required this.scene,
    required this.catchCallback,
    required this.boxContainer,
  });

  final MainScene scene;

  final BoxContainer boxContainer;
  final CatchCallback catchCallback;

  final Map<RecycleType, List<Sprite>> _fallenAssets = <RecycleType, List<Sprite>>{};
  final Map<RecycleType, int> _fallenReiteration = <RecycleType, int>{};
  final List<QuadraticBezier> trajectory = List.empty(growable: true);
  final List<QuadraticBezier> leftTrajectory = List.empty(growable: true);
  final Paint paint = Paint()..filterQuality = FilterQuality.high;

  RecycleType? _reiterationTyped;
  late double _leftFallenInitialPositionX;
  late double _fallenInitialPositionX;
  late double _commonFallenInitialPositionY;
  late double _fallenWidth;
  late double _fallenFinalPointPositionX;
  late double _fallenFinalPointPositionY;

  @override
  void render(Canvas canvas) {
    for (final child in children) {
      child.render(canvas);
    }
  }

  @override
  FutureOr<void> onLoad() {
    _fillAssetsContainer();
    _fillReiterationContainer();
    return super.onLoad();
  }

  //todo final point should be pined to center of the middle box
  void resize(Size size) {
    final tile = game.sizeConfig.tileSize;

    _fallenWidth = tile * DropContainerConfig.dropSize;

    _fallenFinalPointPositionX = size.width / 2;
    _fallenFinalPointPositionY = boxContainer.y - (tile * DropContainerConfig.finalDropY);

    _fallenInitialPositionX = (size.width / 2) * DropContainerConfig.firstDropX;
    _leftFallenInitialPositionX = (size.width / 2) * DropContainerConfig.secondDropX;

    _commonFallenInitialPositionY = size.height - (tile * DropContainerConfig.commonDropY);

    for (var i = 0; i < DropContainerConfig.trajectoryCount; i++) {
      trajectory.add(QuadraticBezier([
        vector_math.Vector2(_fallenInitialPositionX, _commonFallenInitialPositionY),
        vector_math.Vector2(_fallenFinalPointPositionX,
            doubleInRange(_commonFallenInitialPositionY, _commonFallenInitialPositionY / 2)),
        vector_math.Vector2(_fallenFinalPointPositionX, _fallenFinalPointPositionY)
      ]));

      leftTrajectory.add(QuadraticBezier([
        vector_math.Vector2(_leftFallenInitialPositionX, _commonFallenInitialPositionY),
        vector_math.Vector2(_fallenFinalPointPositionX,
            doubleInRange(_commonFallenInitialPositionY, _commonFallenInitialPositionY / 2)),
        vector_math.Vector2(_fallenFinalPointPositionX, _fallenFinalPointPositionY)
      ]));
    }
  }

  @override
  void onGameResize(Vector2 size) {
    if (isLoaded) {
      resize(size.toSize());
    }
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (scene.isDestroy) {
      removeFromParent();
    }
  }

  void genDrop({
    required double speedMin,
    required double speedMax,
    required List<Drop> dropDiversityList,
  }) {
    //todo here check if preveosly spawend fallen was the same type
    final t = _getDiversityIndex(dropDiversityList);

    final n = RecycleType.values.indexOf(dropDiversityList[t].type);

    final s = (dropDiversityList[t].varietyBounder - 1) <= 0
        ? 0
        : _getTypedDiversity(RecycleType.values[t], dropDiversityList[t].varietyBounder);

    final i = Random().nextInt(DropContainerConfig.trajectoryCount);

    final isLeft = Random().nextBool();

    final fallen = Fallen(
        sprite: s <= (_fallenAssets[RecycleType.values[n]]!.length - 1)
            ? _fallenAssets[RecycleType.values[n]]![s]
            : _fallenAssets[RecycleType.values[n]]![0],
        type: RecycleType.values[n],
        catchCallback: catchCallback,
        wave: scene.currentWave,
        scene: scene,
        paint: paint,
        cubicCurve: isLeft ? trajectory[i] : leftTrajectory[i],
        speed: doubleInRange(speedMin, speedMax),
        isLeft: isLeft);
    fallen.angle = isLeft ? sin(random.nextDouble()) : -sin(random.nextDouble());
    fallen.rotation =
        doubleInRange(DropContainerConfig.minInitialAngle, DropContainerConfig.maxInitialAngle);
    fallen.x = fallen.cubicCurve.pointAt(0).x;
    fallen.y = fallen.cubicCurve.pointAt(0).y;
    fallen.width = _fallenWidth;
    fallen.height = _fallenWidth;
    fallen.isVisible = true;
    add(fallen);
  }

  void _fillAssetsContainer() {
    for (final dropType in RecycleType.values) {
      final list = <Sprite>[];
      for (final index in AssetsLoader().getAssets(dropType)) {
        list.add(Sprite(game.images.fromCache(index)));
      }
      _fallenAssets[dropType] = list;
    }
  }

  void _fillReiterationContainer() {
    for (final index in RecycleType.values) {
      _fallenReiteration[index] = 0;
    }
  }

  int _getTypedDiversity(RecycleType type, int diversityBounder) {
    var i = 0;
    do {
      i = Random().nextInt(diversityBounder);
    } while (_fallenReiteration[type]?.compareTo(i) == 0);
    _fallenReiteration[type] = i;
    return i;
  }

  int _getDiversityIndex(List<Drop> dropDiversity) {
    var result = 0;
    final listLength = dropDiversity.length;
    if (listLength == 1) {
      return result;
    } else {
      result = Random().nextInt(listLength);

      if (_reiterationTyped != null && _reiterationTyped == dropDiversity[result].type) {
        result = _chooseIndex(result, listLength - 1);
      }

      _reiterationTyped = dropDiversity[result].type;
    }
    return result;
  }

  int _chooseIndex(int initial, int constraints) {
    var result = initial;
    if (initial == constraints) {
      result = constraints - 1;
    } else if (initial == 0) {
      result = ++result;
    } else {
      result = --result;
    }
    return result;
  }
}
