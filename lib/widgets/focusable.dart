import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recyclo/common/extensions/platform/extended_platform.dart';

class Focusable extends StatelessWidget {
  const Focusable({
    required this.builder,
    this.autofocus = false,
    this.onFocusChange,
    super.key,
  });

  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext, bool) builder;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;

  @override
  Widget build(BuildContext context) {
    if (ExtendedPlatform.isTv) {
      return _Focusable(
        builder: builder,
        autofocus: autofocus,
        onFocusChange: onFocusChange,
      );
    }

    return builder(context, false);
  }
}

class _Focusable extends StatefulWidget {
  const _Focusable({
    required this.builder,
    this.autofocus = false,
    this.onFocusChange,
  });

  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext, bool) builder;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;

  @override
  State<_Focusable> createState() => _FocusableState();
}

class _FocusableState extends State<_Focusable> {
  final FocusNode _focusNode = FocusNode();
  final _key = GlobalKey();
  _CallbackHolder? _callbackHolder;

  @override
  void initState() {
    super.initState();
    if (widget.autofocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      key: _key,
      onKey: (node, key) {
        if (key is! RawKeyDownEvent) {
          return KeyEventResult.ignored;
        }

        if (key.hasSubmitIntent) {
          _calculateSubmitActions();
          _callbackHolder?.onSubmit?.call();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      focusNode: _focusNode,
      onFocusChange: (newValue) {
        widget.onFocusChange?.call(_focusNode.hasFocus);
        setState(() {});
      },
      child: widget.builder(context, _focusNode.hasFocus),
    );
  }

  void _extractSubmitActionFromInteractiveWidget(Element element) {
    final widget = element.widget;

    if (widget is GestureDetector) {
      _callbackHolder = _CallbackHolder(
          onSubmit: widget.onTap, onLongPress: widget.onLongPress);

      return;
    }

    if (widget is InkWell) {
      _callbackHolder = _CallbackHolder(
          onSubmit: widget.onTap, onLongPress: widget.onLongPress);

      return;
    }

    element.visitChildElements(_extractSubmitActionFromInteractiveWidget);
  }

  void _calculateSubmitActions() {
    _key.currentContext!
        .visitChildElements(_extractSubmitActionFromInteractiveWidget);
  }
}

class _CallbackHolder {
  _CallbackHolder({
    required this.onLongPress,
    required this.onSubmit,
  });

  VoidCallback? onSubmit;
  VoidCallback? onLongPress;
}

extension SubmitAction on RawKeyEvent {
  bool get hasSubmitIntent =>
      logicalKeysTap.contains(logicalKey) || logicalKey.debugName == 'Select';
}

const logicalKeysTap = [
  LogicalKeyboardKey.select,
  LogicalKeyboardKey.enter,
  LogicalKeyboardKey.space,
  LogicalKeyboardKey.gameButtonA,
];
