// lib/shared/utils/platform/csv_downloader_stub.dart
//
// Stub used only when neither dart:html nor dart:io is available.
// In practice this is never reached in a Flutter build.

import 'package:flutter/material.dart';

Future<void> downloadCsvPlatform(
  BuildContext context,
  String filename,
  String content,
) async {
  // No-op stub
}
