import 'package:flutter/widgets.dart';

const _kScreenWidth = 720.0;

class ScaleWidget extends StatelessWidget {
  const ScaleWidget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ratio = _getScaleRatio(context);

    return FractionallySizedBox(
      widthFactor: 1 / ratio,
      heightFactor: 1 / ratio,
      child: Transform.scale(
        scale: ratio,
        child: Center(
          child: SizedBox(
            width: _kScreenWidth,
            height: _kScreenWidth *
                MediaQuery.of(context).size.height /
                MediaQuery.of(context).size.width,
            child: child,
          ),
        ),
      ),
    );
  }

  double _getScaleRatio(BuildContext context) {
    return _getWindowSizeInLogicalPixels(context).width / _kScreenWidth;
  }

  Size _getWindowSizeInLogicalPixels(BuildContext context) {
    var physicalSize = View.of(context).physicalSize;
    final pixelRatio = View.of(context).devicePixelRatio;

    if (physicalSize.width < physicalSize.height) {
      physicalSize = Size(physicalSize.height, physicalSize.width);
    }

    return physicalSize / pixelRatio;
  }
}
