import 'package:flutter/material.dart';
import 'package:recyclo/common/assets/colors.gen.dart';

class RecycloSwitch extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onToggle;

  const RecycloSwitch({
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 70,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isEnabled
              ? FlutterGameChallengeColors.toggleSwitchEnabled
              : FlutterGameChallengeColors.toggleSwitchDisabled,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: FlutterGameChallengeColors.primary1,
          ),
        ),
        child: AnimatedAlign(
          curve: Curves.easeInOutCirc,
          duration: const Duration(
            milliseconds: 200,
          ),
          alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: FlutterGameChallengeColors.detailsBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                width: 2,
                color: FlutterGameChallengeColors.primary1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}