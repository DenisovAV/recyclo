import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/catcher_game/components.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/common.dart';

class BoxContainer extends PositionComponent with HasGameRef<CatcherGame> {
  BoxContainer() {
    super.anchor = Anchor.centerLeft;
  }

  final List<ItemType> initialBoxList = List.from(ItemType.values);

  late List<Box> boxContainerList;
  late ItemType chosenBoxType;
  late Box chosenBox;
  late Rect boxContainerClip;
  late List<double> _hooksPosX;
  late ScrollDirection _direction;
  late Rect _containerClip;
  late double _chosenPositionY;
  late double _chosenBoxWidth;
  late double _swappingBoxWidth;
  late double _distortionDistance;
  final EffectController effectController = EffectController(
    duration: 0.5,
    reverseDuration: 0.5,
  );

  bool _startAnimationToHook = false;
  bool _finishAnimation = false;
  bool _resizeInProgress = false;

  void resize(Size size) {
    _resizeInProgress = true;

    final tile = game.sizeConfig.tileSize;
    final screenSize = game.canvasSize.toSize();

    _chosenBoxWidth = initialBoxList.length == 7
        ? (tile * (BoxContainerConfig.bigSevenBoxSize))
        : (tile * (BoxContainerConfig.bigBoxSize));
    _swappingBoxWidth = initialBoxList.length == 7
        ? (tile * (BoxContainerConfig.smallSevenBoxSize))
        : (tile * (BoxContainerConfig.smallBoxSize));

    _distortionDistance = initialBoxList.length == 7
        ? BoxContainerConfig.distortionSevenDistance
        : BoxContainerConfig.distortionDistance;

    width = screenSize.width - (tile * BoxContainerConfig.containerTouchArea);
    height = _chosenBoxWidth + _swappingBoxWidth;

    x = 0;
    y = initialBoxList.length == 7
        ? screenSize.height -
            (tile * BoxContainerConfig.containerSevenPositionY)
        : screenSize.height - (tile * BoxContainerConfig.containerPositionY);

    _chosenPositionY =
        y - (_chosenBoxWidth - _swappingBoxWidth) / initialBoxList.length;

    _containerClip = Rect.fromLTRB(
      x,
      height,
      screenSize.width,
      screenSize.height,
    );
    boxContainerClip = Rect.fromCenter(
      center: Offset(screenSize.width / 2, y),
      width: screenSize.width,
      height: _chosenBoxWidth * BoxContainerConfig.containerClipSize,
    );

    final spacing = initialBoxList.length == 7
        ? (tile * BoxContainerConfig.gapSevenSize)
        : (tile * BoxContainerConfig.gapSize);

    _resizeEachBox(
      spacing: spacing,
      bigWidth: _chosenBoxWidth,
      smallWidth: _swappingBoxWidth,
      width: size.width,
    );

    _distributeAssetsBoxesOnScreen();

    _resizeInProgress = false;
  }

  @override
  FutureOr<void> onLoad() async {
    await _initBoxContainer();

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    if (isLoaded) {
      resize(size.toSize());
    }
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    if (game.status != CatcherGameStatus.result) {
      canvas.save();
      for (final comp in children) {
        _renderComponent(canvas, comp);
      }
      canvas.restore();
    }
  }

  @override
  void update(double dt) {
    if (_startAnimationToHook) {
      for (final box in boxContainerList) {
        final stepDistance =
            (game.sizeConfig.tileSize * BoxContainerConfig.boxAnimationSpeed) *
                dt;
        final toTarget = Offset(
              _hooksPosX[box.order],
              box.order == 0 ? _chosenPositionY : y,
            ) -
            Offset(box.x, box.y);
        if (stepDistance < toTarget.distance) {
          final stepToTarget =
              Offset.fromDirection(toTarget.direction, stepDistance);
          box.setByRect(box.toRect().shift(stepToTarget));
        } else {
          if (!_finishAnimation) {
            _finishAnimation = true;
          }
        }
      }
      if (_finishAnimation) {
        resize(game.canvasSize.toSize());
        _startAnimationToHook = false;
        _finishAnimation = false;
      } else {
        _resizeCloseToMiddle();
      }
    }

    if (game.isRemoving) {
      removeFromParent();
    }
  }

  void handleDragStart() {
    if (!_resizeInProgress) {
      _startAnimationToHook = false;
      resize(game.canvasSize.toSize());
      _distributeAssetsBoxesOnScreen();
    }
  }

  void handleDragUpdate(DragUpdateDetails details) {
    if (!_resizeInProgress) {
      details.delta.direction > 0.0
          ? _direction = ScrollDirection.forward
          : _direction = ScrollDirection.reverse;

      if (_direction == ScrollDirection.forward) {
        for (final box in boxContainerList) {
          box.x -= details.delta.distance;
        }
      } else {
        for (final box in boxContainerList) {
          box.x += details.delta.distance;
        }
      }
      _resizeCloseToMiddle();
    }
  }

  void handleDragEnd() {
    if (!_resizeInProgress) {
      double minimalDistance;
      var averageMinimal = double.maxFinite;
      final map = <int, int>{};

      final startBox = boxContainerList.firstWhere((box) => box.order == 0);
      minimalDistance =
          Vector2(startBox.x, y).distanceTo(Vector2(_hooksPosX[0], y));
      final distance =
          Vector2(startBox.x, y).distanceTo(Vector2(_hooksPosX[0], y));
      averageMinimal = distance.roundToDouble();

      for (final box in boxContainerList) {
        final distance =
            Vector2(box.x, y).distanceTo(Vector2(_hooksPosX[0], y));
        if (box.order != 0 && distance.compareTo(minimalDistance) == -1) {
          if (distance.compareTo(averageMinimal) == -1) {
            averageMinimal = distance.roundToDouble();
            if (boxContainerList.indexOf(box).isEven) {
              _direction = ScrollDirection.forward;
            } else {
              _direction = ScrollDirection.reverse;
            }
          }
        }
      }

      for (final hookPosX in _hooksPosX) {
        final index = _hooksPosX.indexOf(hookPosX);
        int? boxIndex;
        for (final box in boxContainerList) {
          final distance = Vector2(box.x, y).distanceTo(Vector2(hookPosX, y));
          if (distance.roundToDouble() == averageMinimal) {
            boxIndex = box.order;
          }
        }

        if (boxIndex == null && averageMinimal != double.maxFinite) {
          if (_direction == ScrollDirection.reverse) {
            boxIndex = index + 1;
          } else if (_direction == ScrollDirection.forward) {
            boxIndex = index - 1;
          }
        }

        map[boxIndex!] = index;
      }

      if (averageMinimal != double.maxFinite &&
          !map.keys.contains(-1) &&
          map.keys.length == _hooksPosX.length) {
        for (final box in boxContainerList) {
          box.order = map[box.order]!;
          _chosenBoxType(box);
        }
      }
      _startAnimationToHook = true;
    }
  }

  void _distributeAssetsBoxesOnScreen() {
    var order = initialBoxList.length - 1;
    var subtract = true;
    final map = <int, Box>{};
    boxContainerList.sort((a, b) => a.order.compareTo(b.order));

    for (final box in boxContainerList) {
      if (box.order < initialBoxList.length) {
        map[box.order] = box;
      }
    }

    for (final box in boxContainerList) {
      final index = boxContainerList.indexOf(box);
      if (index.isEven && index >= initialBoxList.length) {
        boxContainerList[index].sprite = map[order]!.sprite;
        boxContainerList[index].type = map[order]!.type;
        if (order == 0) {
          subtract = false;
        }
        subtract ? order-- : order++;
      } else if (index.isOdd && index >= initialBoxList.length) {
        boxContainerList[index].sprite = map[order]!.sprite;
        boxContainerList[index].type = map[order]!.type;
        if (order != 0) {
          subtract ? order-- : order++;
        }
      }
    }
  }

  // TODO(viktor): should come up with the better approach to handle over swipe
  void _resizeEachBox({
    required double spacing,
    required double smallWidth,
    required double bigWidth,
    required double width,
  }) {
    for (final hook in _hooksPosX) {
      switch (_hooksPosX.indexOf(hook)) {
        case 0:
          _hooksPosX[0] = width / 2;
        case 1:
          _hooksPosX[1] = (_hooksPosX[0] - spacing) - (smallWidth / 2);
        case 2:
          _hooksPosX[2] = (_hooksPosX[0] + spacing) + (smallWidth / 2);
        case 3:
          _hooksPosX[3] = (_hooksPosX[1] - spacing) - (smallWidth / 2);
        case 4:
          _hooksPosX[4] = (_hooksPosX[2] + spacing) + (smallWidth / 2);
        case 5:
          _hooksPosX[5] = (_hooksPosX[3] - spacing) - (smallWidth / 2);
        case 6:
          _hooksPosX[6] = (_hooksPosX[4] + spacing) + (smallWidth / 2);
        case 7:
          _hooksPosX[7] = (_hooksPosX[5] - spacing) - (smallWidth / 2);
        case 8:
          _hooksPosX[8] = (_hooksPosX[6] + spacing) + (smallWidth / 2);
        case 9:
          _hooksPosX[9] = (_hooksPosX[7] - spacing) - (smallWidth / 2);
        case 10:
          _hooksPosX[10] = (_hooksPosX[8] + spacing) + (smallWidth / 2);
        case 11:
          _hooksPosX[11] = (_hooksPosX[9] - spacing) - (smallWidth / 2);
        case 12:
          _hooksPosX[12] = (_hooksPosX[10] + spacing) + (smallWidth / 2);
        case 13:
          _hooksPosX[13] = (_hooksPosX[11] - spacing) - (smallWidth / 2);
        case 14:
          _hooksPosX[14] = (_hooksPosX[12] + spacing) + (smallWidth / 2);
        case 15:
          _hooksPosX[15] = (_hooksPosX[13] - spacing) - (smallWidth / 2);
        case 16:
          _hooksPosX[16] = (_hooksPosX[14] + spacing) + (smallWidth / 2);
        case 17:
          _hooksPosX[17] = (_hooksPosX[15] - spacing) - (smallWidth / 2);
        case 18:
          _hooksPosX[18] = (_hooksPosX[16] + spacing) + (smallWidth / 2);
        case 19:
          _hooksPosX[19] = (_hooksPosX[17] - spacing) - (smallWidth / 2);
        case 20:
          _hooksPosX[20] = (_hooksPosX[18] + spacing) + (smallWidth / 2);
      }
    }

    for (final box in boxContainerList) {
      if (box.order == 0) {
        box
          ..position = Vector2(_hooksPosX[0], _chosenPositionY)
          ..size = Vector2(bigWidth, bigWidth);
      } else {
        box
          ..position = Vector2(_hooksPosX[box.order], y)
          ..size = Vector2(smallWidth, smallWidth);
      }
    }
  }

  void _renderComponent(Canvas canvas, Component c) {
    canvas
      ..save()
      ..clipRect(
        _containerClip,
      );
    c.render(canvas);
    canvas.restore();
  }

  double _distanceToSize(double value) {
    final i = (value - 0) /
            ((game.sizeConfig.tileSize * _distortionDistance) - 0) *
            (_swappingBoxWidth - _chosenBoxWidth) +
        _chosenBoxWidth;

    return i;
  }

  double _sizeToPosition(double value) {
    final i = (value - _swappingBoxWidth) /
            (_chosenBoxWidth - _swappingBoxWidth) *
            (_chosenPositionY - y) +
        y;

    return i;
  }

  void _resizeCloseToMiddle() {
    for (final box in boxContainerList) {
      if (box.position.distanceTo(Vector2(size.toSize().width / 2, box.y)) <
          game.sizeConfig.tileSize * _distortionDistance) {
        final s = _distanceToSize(
          box.position.distanceTo(Vector2(size.toSize().width / 2, box.y)),
        );
        box
          ..width = s
          ..height = s
          ..y = _sizeToPosition(s);

        _chosenBoxType(box);
      }
    }
  }

  void _chosenBoxType(Box box) {
    if (box.width >= _chosenBoxWidth * BoxContainerConfig.chosenBoxMinSize &&
        chosenBoxType != box.type) {
      chosenBoxType = box.type;
      chosenBox = box;
    }
  }

  Rect boxClip() {
    return Rect.fromCenter(
      center: chosenBox.center.toOffset(),
      width: size.toSize().width,
      height: chosenBox.height / 1.7,
    );
  }

  // TODO(viktor): should come up with the better approach to handle over swipe
  Future<void> _initBoxContainer() async {
    initialBoxList.shuffle();

    boxContainerList = List<Box>.empty(growable: true);

    for (var i = 0;
        i < initialBoxList.length * BoxContainerConfig.containerCapacityExpand;
        i++) {
      if (i < initialBoxList.length) {
        boxContainerList.add(
          Box(
            sprite: Sprite(game.images.fromCache(_getAssetPath(i))),
            type: initialBoxList[i],
            order: i,
          ),
        );
      } else {
        boxContainerList.add(
          Box(
            // Index is zero is same box as the center one, to propagate
            // the same image from both sides.
            sprite: Sprite(game.images.fromCache(_getAssetPath(0))),
            type: initialBoxList[1],
            order: i,
          ),
        );
      }
    }

    await addAll(boxContainerList);

    _hooksPosX = List<double>.filled(
      initialBoxList.length * BoxContainerConfig.containerCapacityExpand,
      0,
    );

    chosenBoxType = boxContainerList[0].type;
    chosenBox = boxContainerList[0];
    boxContainerList[0].isChosen = true;
  }

  String _getAssetPath(int index) => switch (initialBoxList[index]) {
        ItemType.organic => Assets.images.catcher.boxes.organic.path,
        ItemType.glass => Assets.images.catcher.boxes.glass.path,
        ItemType.plastic => Assets.images.catcher.boxes.plastic.path,
        ItemType.electronic => Assets.images.catcher.boxes.electric.path,
        ItemType.paper => Assets.images.catcher.boxes.paper.path,
      };

  void handleCatch({
    required bool isSuccessful,
  }) {
    chosenBox.animateCatch(isSuccessful: isSuccessful);
  }
}
