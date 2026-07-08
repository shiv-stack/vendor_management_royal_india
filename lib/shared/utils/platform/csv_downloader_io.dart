// lib/shared/utils/platform/csv_downloader_io.dart
//
// Native implementation for Android / iOS / desktop.
//
// ┌─────────────────────────────────────────────────────────────┐
// │  ANDROID                                                    │
// │  Writes a temp file to the app cache, then fires the native │
// │  share sheet via share_plus so the user can pick "Save to   │
// │  Files", WhatsApp, Email, Drive, etc.                       │
// │                                                             │
// │  WHY NOT path_provider Documents on Android?                │
// │  getApplicationDocumentsDirectory() maps to the app's       │
// │  private data partition (/data/user/0/…). That location is  │
// │  invisible to the system File Manager and any other app,    │
// │  making the exported file effectively inaccessible.         │
// │                                                             │
// │  OTHER NATIVE PLATFORMS (iOS, Windows, macOS, Linux)        │
// │  Saves directly to the platform's Documents directory and   │
// │  shows a SnackBar with the path — same as before.           │
// └─────────────────────────────────────────────────────────────┘

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadCsvPlatform(
  BuildContext context,
  String filename,
  String content,
) async {
  if (Platform.isAndroid) {
    await _shareOnAndroid(context, filename, content);
  } else {
    await _saveToDocuments(context, filename, content);
  }
}

// ── Android: write temp file → native share sheet ─────────────────────────────

Future<void> _shareOnAndroid(
  BuildContext context,
  String filename,
  String content,
) async {
  try {
    // Write to the app cache directory (readable by the share intent).
    // We use cache rather than Documents so we don't accumulate stale files
    // in private storage; the OS can clear the cache dir when space is low.
    final cacheDir = await getTemporaryDirectory();
    final file = File('${cacheDir.path}/$filename');
    await file.writeAsBytes(utf8.encode(content), flush: true);

    // Open the native Android share sheet.
    // The user can choose "Save to Files / Downloads", WhatsApp, Email, etc.
    final xFile = XFile(
      file.path,
      mimeType: 'text/csv',
      name: filename,
    );

    // share_plus v10 uses the static Share.shareXFiles() API.
    await Share.shareXFiles(
      [xFile],
      subject: filename, // pre-fills subject in e-mail clients
    );

    // Show a brief informational snackbar after the share sheet is dismissed.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.share_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('Share sheet opened for $filename')),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }
}

// ── Other native platforms: save to Documents directory ───────────────────────

Future<void> _saveToDocuments(
  BuildContext context,
  String filename,
  String content,
) async {
  try {
    final dir  = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    // Write as raw bytes so the UTF-8 BOM (\\uFEFF → 0xEF 0xBB 0xBF)
    // is preserved exactly — guarantees Excel / desktop apps parse columns.
    await file.writeAsBytes(utf8.encode(content), flush: true);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CSV saved successfully!',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      file.path,
                      style: const TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }
}
