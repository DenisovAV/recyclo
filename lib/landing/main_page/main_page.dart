import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          _SectionWidget(
            color: Colors.red,
            child: Center(child: Text('Pip')),
          ),
          _SectionWidget(
            color: Colors.green,
            child: Center(child: Text('Pup')),
          ),
          _SectionWidget(
            color: Colors.yellow,
            child: Center(child: Text('Pap')),
          ),
          _SectionWidget(
            color: Colors.blue,
            child: Center(child: Text('Pep')),
          ),
        ],
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  const _SectionWidget({
    required this.child,
    required this.color,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    return Container(
      color: color,
      height: height,
      width: double.maxFinite,
      child: child,
    );
  }
}
