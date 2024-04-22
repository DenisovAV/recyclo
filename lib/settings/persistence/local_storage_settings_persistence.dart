import 'package:recyclo/common/entities/game_difficulty_level_type.dart';
import 'package:recyclo/settings/persistence/settings_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageSettingsPersistence extends SettingsPersistence {
  late final SharedPreferences _sharedPreferences;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  bool getMusicOn({required bool defaultValue}) {
    return _sharedPreferences.getBool('musicOn') ?? defaultValue;
  }

  @override
  bool getSoundsOn({required bool defaultValue}) {
    return _sharedPreferences.getBool('soundsOn') ?? defaultValue;
  }

  @override
  GameDifficultyType getGameDifficulty({
    required GameDifficultyType defaultValue,
  }) {
    final savedDifficulty = _sharedPreferences.getInt('gameDifficulty');

    return savedDifficulty != null
        ? GameDifficultyType.values[savedDifficulty]
        : defaultValue;
  }

  @override
  Future<void> saveMusicOn({required bool isMusicOn}) async {
    await _sharedPreferences.setBool('musicOn', isMusicOn);
  }

  @override
  Future<void> saveSoundsOn({required bool soundsOn}) async {
    await _sharedPreferences.setBool('soundsOn', soundsOn);
  }

  @override
  bool getPenaltyFlag({bool defaultValue = true}) {
    return _sharedPreferences.getBool('penaltyOn') ?? defaultValue;
  }

  @override
  Future<void> setPenalty({required bool value}) async {
    await _sharedPreferences.setBool('penaltyOn', value);
  }

  @override
  String? getCurrentLocale() {
    return _sharedPreferences.getString('currentLocale');
  }

  @override
  Future<void> saveCurrentLocale(String value) {
    return _sharedPreferences.setString('currentLocale', value);
  }

  @override
  Future<bool> setGameDifficulty(GameDifficultyType difficulty) {
    return _sharedPreferences.setInt('gameDifficulty', difficulty.index);
  }
}
