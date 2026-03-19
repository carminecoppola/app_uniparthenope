import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();

  factory UpdateService() {
    return _instance;
  }

  UpdateService._internal();

  // URL del file remoto contente la versione disponibile
  // NOTA: Modifica questo con il tuo server di aggiornamenti
  static const String _updateCheckUrl =
      'https://raw.githubusercontent.com/carminecoppola/app_uniparthenope/main/version.json';

  /// Verifica se esiste una nuova versione disponibile
  Future<Map<String, dynamic>?> checkForUpdate() async {
    try {
      final response = await http.get(Uri.parse(_updateCheckUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.Response('', 500),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> remoteData = jsonDecode(response.body);
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();

        final String currentVersion = packageInfo.version;
        final String remoteVersion = remoteData['version'] ?? '';
        final String releaseNotes = remoteData['releaseNotes'] ?? '';
        final String downloadUrl = remoteData['downloadUrl'] ?? '';

        // Confronta le versioni
        if (_isNewerVersion(remoteVersion, currentVersion)) {
          return {
            'hasUpdate': true,
            'currentVersion': currentVersion,
            'newVersion': remoteVersion,
            'releaseNotes': releaseNotes,
            'downloadUrl': downloadUrl,
          };
        }

        return {
          'hasUpdate': false,
          'currentVersion': currentVersion,
        };
      }

      return null;
    } catch (e) {
      print('Errore nel controllo aggiornamenti: $e');
      return null;
    }
  }

  /// Confronta due versioni (es: 4.0.9 vs 4.0.10)
  bool _isNewerVersion(String remoteVersion, String currentVersion) {
    try {
      final List<int> remoteParts =
          remoteVersion.split('.').map(int.parse).toList();
      final List<int> currentParts =
          currentVersion.split('.').map(int.parse).toList();

      for (int i = 0; i < remoteParts.length; i++) {
        if (remoteParts[i] > currentParts[i]) {
          return true;
        } else if (remoteParts[i] < currentParts[i]) {
          return false;
        }
      }

      return false;
    } catch (e) {
      print('Errore nel confronto versioni: $e');
      return false;
    }
  }

  /// Ottiene la versione corrente dell'app
  Future<String> getCurrentVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
