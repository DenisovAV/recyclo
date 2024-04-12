import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/settings/cubit/settings_cubit.dart';
import 'package:flutter_game_challenge/settings/cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(
        begin: 1,
        end: 0,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, v, child) {
        return LayoutBuilder(builder: (context, constraints) {
          return Transform.translate(
            offset: Offset(
              0,
              constraints.maxHeight * v,
            ),
            child: child,
          );
        });
      },
      child: SafeArea(
        child: Container(
          width: 600,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.images.gears.path),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              opacity: 0.2,
            ),
            color: FlutterGameChallengeColors.detailsBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              left: BorderSide(
                color: FlutterGameChallengeColors.primary1,
                width: 2,
              ),
              top: BorderSide(
                color: FlutterGameChallengeColors.primary1,
                width: 2,
              ),
              right: BorderSide(
                color: FlutterGameChallengeColors.primary1,
                width: 2,
              ),
            ),
          ),
          child: Column(
            children: const [
              _AudioSettings(),
              Divider(
                color: FlutterGameChallengeColors.primary1,
                height: 40,
              ),
              _AccessibilitySettings(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccessibilitySettings extends StatelessWidget {
  const _AccessibilitySettings();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(
            Icons.accessibility_rounded,
            size: 24,
            color: FlutterGameChallengeColors.primary1,
          ),
          const SizedBox(width: 8),
          Text(
            context.l10n.accessibilitySettings,
            style: context.generalTextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioSettings extends StatelessWidget {
  const _AudioSettings();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Theme(
          data: ThemeData(
            switchTheme: SwitchThemeData(
              trackOutlineColor: MaterialStateProperty.all(
                FlutterGameChallengeColors.primary1,
              ),
              thumbColor: MaterialStateProperty.all(
                FlutterGameChallengeColors.primary1,
              ),
              trackColor: MaterialStateProperty.all(
                FlutterGameChallengeColors.detailsBackground,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.settings_rounded,
                    size: 32,
                    color: FlutterGameChallengeColors.primary1,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.gameSettings,
                    style: context.generalTextStyle(
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              Divider(
                color: FlutterGameChallengeColors.primary1,
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.music_note_rounded,
                      size: 24,
                      color: FlutterGameChallengeColors.primary1,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.audioSettings,
                      style: context.generalTextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.musicToggleSetting,
                      style: context.generalTextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Switch(
                    value: state.isMusicEnabled,
                    onChanged: (v) {
                      BlocProvider.of<SettingsCubit>(context).toggleMusicOn();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.soundsToggleSetting,
                      style: context.generalTextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Switch(
                    value: state.isSoundEffectsEnabled,
                    onChanged: (v) {
                      BlocProvider.of<SettingsCubit>(context).toggleSoundsOn();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
