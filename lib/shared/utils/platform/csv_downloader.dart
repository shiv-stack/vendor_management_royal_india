// lib/shared/utils/platform/csv_downloader.dart
//
// Conditional export — Flutter picks the right implementation at compile time:
//   • dart.library.html  → web build  (uses dart:html AnchorElement download)
//   • dart.library.io    → native build (uses path_provider + dart:io)

export 'csv_downloader_stub.dart'
    if (dart.library.html) 'csv_downloader_web.dart'
    if (dart.library.io) 'csv_downloader_io.dart';
