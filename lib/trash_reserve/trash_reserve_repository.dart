import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class TrashReserveRepository {
  TrashReserveRepository();

  late final SharedPreferences _sharedPreferences;
  bool _isInitialized = false;

  final StreamController<TrashReserveModel> _reservedTrashController =
      StreamController<TrashReserveModel>();
  TrashReserveModel _reservedTrash = const TrashReserveModel.empty();

  Stream<TrashReserveModel> get reservedTrashStream =>
      _reservedTrashController.stream;

  TrashReserveModel get reservedTrash => _reservedTrash;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    _sharedPreferences = await SharedPreferences.getInstance();

    final reservedTrash = TrashReserveModel(
      // plastic: _sharedPreferences.getInt(_StorageKeys.plasticCountKey) ?? 0,
      // organic: _sharedPreferences.getInt(_StorageKeys.organicCountKey) ?? 0,
      // glass: _sharedPreferences.getInt(_StorageKeys.glassCountKey) ?? 0,
      // paper: _sharedPreferences.getInt(_StorageKeys.paperCountKey) ?? 0,
      // energy: _sharedPreferences.getInt(_StorageKeys.energyCountKey) ?? 0,
      //TODO Remove it later. Just for test
      plastic: _sharedPreferences.getInt(_StorageKeys.plasticCountKey) ?? 130,
      organic: _sharedPreferences.getInt(_StorageKeys.organicCountKey) ?? 16,
      glass: _sharedPreferences.getInt(_StorageKeys.glassCountKey) ?? 323,
      paper: _sharedPreferences.getInt(_StorageKeys.paperCountKey) ?? 465,
      energy: _sharedPreferences.getInt(_StorageKeys.energyCountKey) ?? 990,
    );

    _reservedTrash = reservedTrash;

    _reservedTrashController.add(_reservedTrash);
  }

  Future<void> addResource({
    int plastic = 0,
    int organic = 0,
    int glass = 0,
    int paper = 0,
    int energy = 0,
  }) async {
    _reservedTrash = _reservedTrash.copyWith(
      plastic: _reservedTrash.plastic + plastic,
      organic: _reservedTrash.organic + organic,
      glass: _reservedTrash.glass + glass,
      paper: _reservedTrash.paper + paper,
      energy: _reservedTrash.energy + energy,
    );

    _reservedTrashController.add(_reservedTrash);

    unawaited(_updateSharedStorage());
  }

  Future<void> removeResources({
    int plastic = 0,
    int organic = 0,
    int glass = 0,
    int paper = 0,
    int energy = 0,
  }) async {
    _reservedTrash = _reservedTrash.copyWith(
      plastic: _reservedTrash.plastic - plastic,
      organic: _reservedTrash.organic - organic,
      glass: _reservedTrash.glass - glass,
      paper: _reservedTrash.paper - paper,
      energy: _reservedTrash.energy - energy,
    );

    _reservedTrashController.add(_reservedTrash);

    unawaited(_updateSharedStorage());
  }

  Future<void> _updateSharedStorage() async {
    if (_sharedPreferences.getInt(_StorageKeys.plasticCountKey) !=
        _reservedTrash.plastic) {
      await _sharedPreferences.setInt(
        _StorageKeys.plasticCountKey,
        _reservedTrash.plastic,
      );
    }

    if (_sharedPreferences.getInt(_StorageKeys.organicCountKey) !=
        _reservedTrash.organic) {
      await _sharedPreferences.setInt(
        _StorageKeys.organicCountKey,
        _reservedTrash.organic,
      );
    }

    if (_sharedPreferences.getInt(_StorageKeys.glassCountKey) !=
        _reservedTrash.glass) {
      await _sharedPreferences.setInt(
        _StorageKeys.glassCountKey,
        _reservedTrash.glass,
      );
    }

    if (_sharedPreferences.getInt(_StorageKeys.paperCountKey) !=
        _reservedTrash.paper) {
      await _sharedPreferences.setInt(
        _StorageKeys.paperCountKey,
        _reservedTrash.paper,
      );
    }

    if (_sharedPreferences.getInt(_StorageKeys.energyCountKey) !=
        _reservedTrash.energy) {
      await _sharedPreferences.setInt(
        _StorageKeys.energyCountKey,
        _reservedTrash.energy,
      );
    }
  }
}

class TrashReserveModel {
  const TrashReserveModel({
    required this.plastic,
    required this.organic,
    required this.glass,
    required this.paper,
    required this.energy,
  });

  const TrashReserveModel.empty()
      : plastic = 0,
        organic = 0,
        glass = 0,
        paper = 0,
        energy = 0;

  final int plastic;
  final int organic;
  final int glass;
  final int paper;
  final int energy;

  TrashReserveModel copyWith({
    int? plastic = 0,
    int? organic = 0,
    int? glass = 0,
    int? paper = 0,
    int? energy = 0,
  }) {
    return TrashReserveModel(
      plastic: plastic ?? this.plastic,
      organic: organic ?? this.organic,
      glass: glass ?? this.glass,
      paper: paper ?? this.paper,
      energy: energy ?? this.energy,
    );
  }
}

class _StorageKeys {
  static const plasticCountKey = 'plasticTrashCount';
  static const organicCountKey = 'organicTrashCount';
  static const glassCountKey = 'glassTrashCount';
  static const paperCountKey = 'paperTrashCount';
  static const energyCountKey = 'energyTrashCount';
}
