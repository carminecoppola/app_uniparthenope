import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String newVersion;
  final String releaseNotes;
  final String? downloadUrl;
  final VoidCallback? onDismiss;

  const UpdateDialog({
    super.key,
    required this.currentVersion,
    required this.newVersion,
    required this.releaseNotes,
    this.downloadUrl,
    this.onDismiss,
  });

  Future<void> _launchUpdate() async {
    if (downloadUrl != null && downloadUrl!.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(downloadUrl!))) {
          await launchUrl(
            Uri.parse(downloadUrl!),
            mode: LaunchMode.externalApplication,
          );
        }
      } catch (_) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.system_update, color: Colors.blue),
          SizedBox(width: 8),
          Text('Aggiornamento disponibile'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Una nuova versione è disponibile!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Versione attuale: $currentVersion',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Nuova versione: $newVersion',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (releaseNotes.isNotEmpty) ...[
            Text(
              'Note di rilascio:',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 80,
              child: SingleChildScrollView(
                child: Text(
                  releaseNotes,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss?.call();
          },
          child: const Text('Più tardi'),
        ),
        ElevatedButton.icon(
          onPressed: _launchUpdate,
          icon: const Icon(Icons.download),
          label: const Text('Aggiorna ora'),
        ),
      ],
    );
  }
}

/// Widget helper per mostrare il dialog di aggiornamento
void showUpdateDialogIfNeeded(
  BuildContext context, {
  required String currentVersion,
  required String newVersion,
  required String releaseNotes,
  String? downloadUrl,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return UpdateDialog(
        currentVersion: currentVersion,
        newVersion: newVersion,
        releaseNotes: releaseNotes,
        downloadUrl: downloadUrl,
      );
    },
  );
}

/// Widget Snackbar per notificare aggiornamento disponibile
void showUpdateSnackBar(BuildContext context,
    {required String newVersion, VoidCallback? onTap}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Nuova versione disponibile: $newVersion'),
      action: SnackBarAction(
        label: 'Aggiorna',
        onPressed: onTap ?? () {},
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}
