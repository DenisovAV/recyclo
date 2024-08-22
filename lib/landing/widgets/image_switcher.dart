import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';

class ImageSwitcher extends StatefulWidget {
  const ImageSwitcher({super.key, required this.images});

  final List<Image> images;

  @override
  ImageCarouselState createState() => ImageCarouselState();
}

class ImageCarouselState extends State<ImageSwitcher> {
  int _currentIndex = 0;
  // int _time = 0;
  // final int _maxTimerValue = 5;
  late final Timer _timer;

  late final PageController _pageController;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _pageController.animateToPage(
          _currentIndex == widget.images.length - 1 ? 0 : _currentIndex + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void resetTimer() {
    stopTimer();
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    _pageController = PageController();
  }

  @override
  void dispose() {
    stopTimer();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index > widget.images.length - 1 ? 0 : index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return widget.images[index];
            },
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
            (index) => ImageSwitcherDot(index: index, currentIndex: _currentIndex),
          ),
        ),
      ],
    );
  }
}

class ImageSwitcherDot extends StatelessWidget {
  const ImageSwitcherDot({super.key, required this.index, required this.currentIndex});

  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: currentIndex == index ? FlutterGameChallengeColors.primary1 : Colors.transparent,
        shape: BoxShape.circle,
        border: currentIndex != index
            ? Border.all(
                width: 2,
                color: FlutterGameChallengeColors.primary1,
              )
            : null,
      ),
    );
  }
}
