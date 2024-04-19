import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:bezier/bezier.dart';
import 'package:flame/components.dart';
import 'package:recyclo/catcher_game/common/random_generator.dart';
import 'package:recyclo/catcher_game/components.dart';
import 'package:recyclo/catcher_game/game.dart';
import 'package:recyclo/catcher_game/main_scene.dart';
import 'package:recyclo/common/entities/item_type.dart';
import 'package:vector_math/vector_math.dart' as vector_math;

typedef AssetsByItemTypeCallback = List<String> Function(ItemType dropType);

class DropContainer extends PositionComponent
    with RandomGenerator, HasGameRef<CatcherGame> {
  DropContainer({
    required this.scene,
    required this.catchCallback,
    required this.boxContainer,
    required this.checkForWaveReset,
    required this.assetsByItemTypeCallback,
  });

  final MainScene scene;

  final BoxContainer boxContainer;
  final CatchCallback catchCallback;
  final VoidCallback checkForWaveReset;
  final AssetsByItemTypeCallback assetsByItemTypeCallback;

  final Map<ItemType, List<Sprite>> _dropAssets = <ItemType, List<Sprite>>{};
  final Map<ItemType, int> _dropReiteration = <ItemType, int>{};
  final List<QuadraticBezier> trajectory = List.empty(growable: true);
  final List<QuadraticBezier> leftTrajectory = List.empty(growable: true);
  final Paint paint = Paint()..filterQuality = FilterQuality.high;

  ItemType? _reiterationTyped;
  late double _leftDropInitialPositionX;
  late double _dropInitialPositionX;
  late double _commonDropInitialPositionY;
  late double _dropWidth;
  late double _dropFinalPointPositionX;
  late double _dropFinalPointPositionY;

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

  void resize(Size size) {
    final tile = game.sizeConfig.tileSize;
    trajectory.clear();
    leftTrajectory.clear();

    if (children.isNotEmpty) {
      removeAll(children);
      checkForWaveReset();
    }

    _dropWidth = tile * DropContainerConfig.dropSize;

    _dropFinalPointPositionX = size.width / 2;
    _dropFinalPointPositionY =
        boxContainer.y - (tile * DropContainerConfig.finalDropY);

    _dropInitialPositionX = (size.width / 2) * DropContainerConfig.firstDropX;
    _leftDropInitialPositionX =
        (size.width / 2) * DropContainerConfig.secondDropX;

    _commonDropInitialPositionY =
        size.height - (tile * DropContainerConfig.commonDropY);

    for (var i = 0; i < DropContainerConfig.trajectoryCount; i++) {
      trajectory.add(
        QuadraticBezier([
          vector_math.Vector2(
            _dropInitialPositionX,
            _commonDropInitialPositionY,
          ),
          vector_math.Vector2(
            _dropFinalPointPositionX,
            doubleInRange(
              _commonDropInitialPositionY,
              _commonDropInitialPositionY / 2,
            ),
          ),
          vector_math.Vector2(
            _dropFinalPointPositionX,
            _dropFinalPointPositionY,
          ),
        ]),
      );

      leftTrajectory.add(
        QuadraticBezier([
          vector_math.Vector2(
            _leftDropInitialPositionX,
            _commonDropInitialPositionY,
          ),
          vector_math.Vector2(
            _dropFinalPointPositionX,
            doubleInRange(
              _commonDropInitialPositionY,
              _commonDropInitialPositionY / 2,
            ),
          ),
          vector_math.Vector2(
            _dropFinalPointPositionX,
            _dropFinalPointPositionY,
          ),
        ]),
      );
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
    final t = _getDiversityIndex(dropDiversityList);

    final n = ItemType.values.indexOf(dropDiversityList[t].type);

    final s = (dropDiversityList[t].varietyBounder - 1) <= 0
        ? 0
        : _getTypedDiversity(
            ItemType.values[t],
            dropDiversityList[t].varietyBounder,
          );

    final i = Random().nextInt(DropContainerConfig.trajectoryCount);

    final isLeft = Random().nextBool();

    final fallen = DropComponent(
      sprite: s <= (_dropAssets[ItemType.values[n]]!.length - 1)
          ? _dropAssets[ItemType.values[n]]![s]
          : _dropAssets[ItemType.values[n]]![0],
      type: ItemType.values[n],
      catchCallback: catchCallback,
      wave: scene.currentWave,
      paint: paint,
      cubicCurve: isLeft ? trajectory[i] : leftTrajectory[i],
      speed: doubleInRange(speedMin, speedMax),
      isLeft: isLeft,
    );
    fallen
      ..angle = isLeft ? sin(random.nextDouble()) : -sin(random.nextDouble())
      ..rotation = doubleInRange(
        DropContainerConfig.minInitialAngle,
        DropContainerConfig.maxInitialAngle,
      )
      ..x = fallen.cubicCurve.pointAt(0).x
      ..y = fallen.cubicCurve.pointAt(0).y
      ..width = _dropWidth
      ..height = _dropWidth
      ..isVisible = true;

    add(fallen);
  }

  void _fillAssetsContainer() {
    for (final dropType in ItemType.values) {
      final list = <Sprite>[];
      for (final index in assetsByItemTypeCallback(dropType)) {
        list.add(Sprite(game.images.fromCache(index)));
      }
      _dropAssets[dropType] = list;
    }
  }

  void _fillReiterationContainer() {
    for (final index in ItemType.values) {
      _dropReiteration[index] = 0;
    }
  }

  int _getTypedDiversity(ItemType type, int diversityBounder) {
    var i = 0;
    do {
      i = Random().nextInt(diversityBounder);
    } while (_dropReiteration[type]?.compareTo(i) == 0);
    _dropReiteration[type] = i;
    return i;
  }

  int _getDiversityIndex(List<Drop> dropDiversity) {
    var result = 0;
    final listLength = dropDiversity.length;
    if (listLength == 1) {
      return result;
    } else {
      result = Random().nextInt(listLength);

      if (_reiterationTyped != null &&
          _reiterationTyped == dropDiversity[result].type) {
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
