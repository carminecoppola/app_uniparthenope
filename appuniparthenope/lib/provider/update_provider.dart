import 'package:flutter/material.dart';
import 'package:appuniparthenope/service/update_service.dart';

class UpdateProvider extends ChangeNotifier {
  final UpdateService _updateService = UpdateService();

  bool _checkingForUpdate = false;
  Map<String, dynamic>? _updateInfo;

  bool get checkingForUpdate => _checkingForUpdate;
  Map<String, dynamic>? get updateInfo => _updateInfo;

  bool get hasUpdate => _updateInfo?['hasUpdate'] ?? false;
  String get newVersion => _updateInfo?['newVersion'] ?? '';
  String get currentVersion => _updateInfo?['currentVersion'] ?? '';
  String get releaseNotes => _updateInfo?['releaseNotes'] ?? '';
  String get downloadUrl => _updateInfo?['downloadUrl'] ?? '';

  /// Verifica se esiste un aggiornamento disponibile
  Future<void> checkForUpdate() async {
    _checkingForUpdate = true;
    notifyListeners();

    try {
      _updateInfo = await _updateService.checkForUpdate();
      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _checkingForUpdate = false;
      notifyListeners();
    }
  }

  /// Resetta lo stato
  void reset() {
    _updateInfo = null;
    notifyListeners();
  }
}
