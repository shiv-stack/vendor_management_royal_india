// lib/shared/utils/platform/csv_downloader_web.dart
//
// Web implementation — triggers a browser file download using a base64
// data URL. This avoids Blob/TypedArray interop complexity entirely and
// is guaranteed to work correctly in every modern browser.
// This file is ONLY compiled when targeting Flutter Web.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

Future<void> downloadCsvPlatform(
  BuildContext context,
  String filename,
  String content,
) async {
  try {
    // 1. UTF-8 encode the string (preserves the BOM bytes exactly).
    // 2. Base64-encode the raw bytes → a safe ASCII string for the data URL.
    // 3. Embed in a data URL so the browser downloads the exact bytes.
    //    This is far more reliable than the Blob constructor with a JS number
    //    array, which concatenates the string representations of each byte.
    final base64Content = base64Encode(utf8.encode(content));
    final dataUrl = 'data:text/csv;charset=utf-8;base64,$base64Content';

    // Create a hidden <a> element, point it at the data URL, and click it.
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = dataUrl
      ..setAttribute('download', filename)
      ..style.display = 'none';

    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('CSV downloaded: $filename')),
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
