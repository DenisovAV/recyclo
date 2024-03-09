import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

class BoundComponents extends BodyComponent {
  BoundComponents(this._start, this._end);

  final Vector2 _start;
  final Vector2 _end;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(
      shape,
      friction: 0.3,
    );
    final bodyDef = BodyDef(
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    // Do not draw anything for the body itself to ensure it's "transparent"
  }
}
