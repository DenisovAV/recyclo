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
          padding: EdgeInsets.only(
            top: 20,
            left: 12,
            right: 12,
          ),
          decoration: BoxDecoration(
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
              Text(
                context.l10n.gameSettings,
                style: context.generalTextStyle(
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 24),
              _AudioSettings(),
              const SizedBox(height: 36),
              _AccessibilitySettings(),
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
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(
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
      const SizedBox(height: 4),
      Align(
        alignment: Alignment.centerLeft,
        child: _SettingsDropdown(),
      ),
    ]);
  }
}

class _AccessibilitySettings extends StatelessWidget {
  const _AccessibilitySettings();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
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
        ),
        const SizedBox(height: 4),
        _GameSpeedSettings(
          value: 2,
        ),
        const SizedBox(height: 8),
        _SettingToggleItem(
          isEnabled: true,
          onToggle: () {},
          title: context.l10n.penaltySettings,
        ),
        const SizedBox(height: 8),
        _SettingToggleItem(
          isEnabled: false,
          onToggle: () {},
          title: context.l10n.colorSettings,
        ),
        const SizedBox(height: 8),
      ],
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
  final bool isEnabled;
  final VoidCallback onToggle;
  final String title;

  const _SettingToggleItem({
    required this.isEnabled,
    required this.onToggle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: EdgeInsets.symmetric(horizontal: 12),
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
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localisationProvider = context.watch<AppLocalizationsProvider>();

    return DropdownButton<RecycloLanguage>(
      borderRadius: BorderRadius.circular(18),
      value: context.l10n.toAppLanguage(),
      style: context.generalTextStyle(fontSize: 18),
      items: localisationProvider.supportLocales.map<DropdownMenuItem<RecycloLanguage>>(
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
    );
  }
}

class _GameSpeedSettings extends StatelessWidget {
  final int value;

  const _GameSpeedSettings({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
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
                  data: SliderThemeData(
                    trackHeight: 4,
                  ),
                  child: Slider(
                    thumbColor: FlutterGameChallengeColors.primary1,
                    activeColor: FlutterGameChallengeColors.primary1,
                    inactiveColor: FlutterGameChallengeColors.primary1.withOpacity(0.5),
                    onChanged: (value) {},
                    divisions: 2,
                    min: 1,
                    max: 3,
                    value: value.toDouble(),
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
    );
  }
}
