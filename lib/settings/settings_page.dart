import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/app/app_localisations_provider.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/settings/cubit/settings_cubit.dart';
import 'package:recyclo/settings/cubit/settings_state.dart';
import 'package:recyclo/settings/widgets/recyclo_switch.dart';

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
        return LayoutBuilder(
          builder: (context, constraints) {
            return Transform.translate(
              offset: Offset(
                0,
                constraints.maxHeight * v,
              ),
              child: child,
            );
          },
        );
      },
      child: SafeArea(
        bottom: false,
        child: Container(
          width: 600,
          padding: const EdgeInsets.only(
            top: 20,
            left: 12,
            right: 12,
          ),
          decoration: const BoxDecoration(
            color: FlutterGameChallengeColors.detailsBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
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
            children: [
              Semantics(
                header: true,
                focusable: true,
                child: Text(
                  context.l10n.gameSettings,
                  style: context.generalTextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _AudioSettings(),
              const SizedBox(height: 36),
              const _AccessibilitySettings(),
              const SizedBox(height: 36),
              _LanguageSettings(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          excludeSemantics: true,
          label: context.l10n.languageSettings,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
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
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: _SettingsDropdown(),
        ),
      ],
    );
  }
}

class _AccessibilitySettings extends StatelessWidget {
  const _AccessibilitySettings();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Semantics(
                excludeSemantics: true,
                label: context.l10n.accessibilitySettings,
                child: Row(
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
              ),
            ),
            const SizedBox(height: 4),
            _GameSpeedSettings(
              value: state.gameDifficulty,
              onUpdateStatus: (value) {
                BlocProvider.of<SettingsCubit>(context)
                    .setGameDifficulty(value);
              },
            ),
            const SizedBox(height: 8),
            _SettingToggleItem(
              key: UniqueKey(),
              isEnabled: state.isPenaltyEnabled,
              onToggle: () {
                BlocProvider.of<SettingsCubit>(context).togglePenalty();
              },
              title: context.l10n.penaltySettings,
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class _AudioSettings extends StatelessWidget {
  const _AudioSettings();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Semantics(
                excludeSemantics: true,
                label: context.l10n.audioSettings,
                child: Row(
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
              ),
            ),
            const SizedBox(height: 4),
            _SettingToggleItem(
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
          ],
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
    super.key,
  });

  final bool isEnabled;
  final VoidCallback onToggle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: title,
      toggled: isEnabled,
      excludeSemantics: true,
      onTap: onToggle,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: FlutterGameChallengeColors.settingsAccent,
          borderRadius: BorderRadius.circular(18),
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
            RecycloSwitch(
              isEnabled: isEnabled,
              onToggle: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localisationProvider = context.watch<AppLocalizationsProvider>();

    return Semantics(
      label: context.l10n.toAppLanguage().localeName,
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
    return Semantics(
      label: context.l10n.gameSpeedSettings,
      slider: true,
      increasedValue: 3.toString(),
      decreasedValue: 1.toString(),
      value: _value.index.toString(),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: FlutterGameChallengeColors.settingsAccent,
          borderRadius: BorderRadius.circular(18),
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
                    child: Slider(
                      thumbColor: FlutterGameChallengeColors.primary1,
                      activeColor: FlutterGameChallengeColors.primary1,
                      inactiveColor:
                          FlutterGameChallengeColors.primary1.withOpacity(0.5),
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
  }
}
