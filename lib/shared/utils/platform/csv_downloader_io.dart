// lib/shared/utils/platform/csv_downloader_io.dart
//
// Native implementation — saves the CSV file to the app's Documents directory
// and shows a SnackBar with the full file path.
// Works on: Android, iOS, Windows, macOS, Linux.

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadCsvPlatform(
  BuildContext context,
  String filename,
  String content,
) async {
  try {
    // Use Documents directory on all native platforms
    final dir  = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    // Write as raw bytes so the UTF-8 BOM (\uFEFF → 0xEF 0xBB 0xBF)
    // is preserved exactly — guarantees Excel / mobile opens columns correctly.
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
