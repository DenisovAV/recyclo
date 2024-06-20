import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/app/app_localisations_provider.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/settings/cubit/settings_cubit.dart';
import 'package:recyclo/settings/cubit/settings_state.dart';
import 'package:recyclo/settings/widgets/recyclo_switch.dart';
import 'package:recyclo/widgets/focusable.dart';

class SettingsPageTv extends StatelessWidget {
  const SettingsPageTv({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 80,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FlutterGameChallengeColors.detailsBackground,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: FlutterGameChallengeColors.primary1,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  context.l10n.gameSettings,
                  style: context.generalTextStyle(
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
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
                            const SizedBox(height: 8),
                            _SettingToggleItem(
                              autofocus: true,
                              title: context.l10n.musicToggleSetting,
                              isEnabled: state.isMusicEnabled,
                              onToggle: BlocProvider.of<SettingsCubit>(context).toggleMusicOn,
                            ),
                            const SizedBox(height: 8),
                            _SettingToggleItem(
                              title: context.l10n.soundsToggleSetting,
                              isEnabled: state.isSoundEffectsEnabled,
                              onToggle: BlocProvider.of<SettingsCubit>(context).toggleSoundsOn,
                            ),
                            const SizedBox(height: 8),
                            _SettingsDropdown(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
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
                            const SizedBox(height: 8),
                            _GameSpeedSettings(
                              value: state.gameDifficulty,
                              onUpdateStatus: (value) {
                                BlocProvider.of<SettingsCubit>(context).setGameDifficulty(value);
                              },
                            ),
                            const SizedBox(height: 8),
                            _SettingToggleItem(
                              isEnabled: state.isPenaltyEnabled,
                              onToggle: () {
                                BlocProvider.of<SettingsCubit>(context).togglePenalty();
                              },
                              title: context.l10n.penaltySettings,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingToggleItem extends StatelessWidget {
  const _SettingToggleItem({
    required this.isEnabled,
    required this.onToggle,
    required this.title,
    this.autofocus = false,
  });

  final bool isEnabled;
  final VoidCallback onToggle;
  final String title;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Focusable(
        autofocus: autofocus,
        builder: (context, isFocused) => Semantics(
          label: title,
          toggled: isEnabled,
          excludeSemantics: true,
          onTap: onToggle,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isFocused
                  ? FlutterGameChallengeColors.textStroke.withOpacity(0.2)
                  : FlutterGameChallengeColors.settingsAccent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                width: 2,
                color: isFocused ? FlutterGameChallengeColors.textStroke : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.generalTextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: RecycloSwitch(
                    isEnabled: isEnabled,
                    onToggle: onToggle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localisationProvider = context.watch<AppLocalizationsProvider>();

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.language_rounded,
              size: 24,
              color: FlutterGameChallengeColors.primary1,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.languageSettings,
              style: context.generalTextStyle(
                fontSize: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Focusable(
          builder: (context, isFocused) => Semantics(
            label: context.l10n.toAppLanguage().localeName,
            child: Container(
              height: 46,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isFocused
                    ? FlutterGameChallengeColors.textStroke.withOpacity(0.2)
                    : FlutterGameChallengeColors.settingsAccent,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  width: 2,
                  color: isFocused ? FlutterGameChallengeColors.textStroke : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<RecycloLanguage>(
                      borderRadius: BorderRadius.circular(18),
                      value: context.l10n.toAppLanguage(),
                      style: context.generalTextStyle(fontSize: 18),
                      items: localisationProvider.supportLocales
                          .map<DropdownMenuItem<RecycloLanguage>>(
                        (locale) {
                          final language = locale.toAppLanguage();

                          return DropdownMenuItem(
                            value: language,
                            child: Text(
                              language.localeName,
                              style: context.generalTextStyle(
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: context.read<SettingsCubit>().changeLocale,
                    ),
                  ),
                  const RotatedBox(
                    quarterTurns: -1,
                    child: Icon(
                      Icons.chevron_left,
                      size: 36,
                      color: FlutterGameChallengeColors.textStroke,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GameSpeedSettings extends StatefulWidget {
  const _GameSpeedSettings({
    required this.value,
    required this.onUpdateStatus,
  });

  final GameDifficultyType value;
  final void Function(GameDifficultyType) onUpdateStatus;

  @override
  State<_GameSpeedSettings> createState() => _GameSpeedSettingsState();
}

class _GameSpeedSettingsState extends State<_GameSpeedSettings> {
  GameDifficultyType _value = GameDifficultyType.easy;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focusable(
      onKeyEvent: (node, event) {
        if (event is KeyUpEvent) {
          return KeyEventResult.ignored;
        }

        ///Going left
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (_value == GameDifficultyType.easy) {
            return KeyEventResult.ignored;
          } else {
            final neededIndex = GameDifficultyType.values.indexOf(_value) - 1;
            setState(() {
              _value = GameDifficultyType.values[neededIndex];
            });
            widget.onUpdateStatus(_value);
            return KeyEventResult.handled;
          }
        }

        ///Going right
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          if (_value == GameDifficultyType.hard) {
            return KeyEventResult.ignored;
          } else {
            final neededIndex = GameDifficultyType.values.indexOf(_value) + 1;
            setState(() {
              _value = GameDifficultyType.values[neededIndex];
            });
            widget.onUpdateStatus(_value);
            return KeyEventResult.handled;
          }
        }

        return KeyEventResult.ignored;
      },
      builder: (context, isFocused) {
        return Semantics(
          label: context.l10n.gameSpeedSettings,
          excludeSemantics: true,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isFocused
                  ? FlutterGameChallengeColors.textStroke.withOpacity(0.2)
                  : FlutterGameChallengeColors.settingsAccent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                width: 2,
                color: isFocused ? FlutterGameChallengeColors.textStroke : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.gameSpeedSettings,
                  style: context.generalTextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Stack(
                    children: [
                      SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 4,
                        ),
                        child: ExcludeFocus(
                          child: Slider(
                            thumbColor: FlutterGameChallengeColors.primary1,
                            activeColor: FlutterGameChallengeColors.primary1,
                            inactiveColor: FlutterGameChallengeColors.primary1.withOpacity(0.5),
                            onChanged: (value) {
                              setState(() {
                                _value = GameDifficultyType.values[value.toInt()];
                              });
                            },
                            onChangeEnd: (_) {
                              widget.onUpdateStatus(_value);
                            },
                            max: 2,
                            value: _value.index.toDouble(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '1',
                          style: context.generalTextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '3',
                          style: context.generalTextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
