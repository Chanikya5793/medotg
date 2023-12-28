import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PDFScreen extends StatelessWidget {
  final String path;

  const PDFScreen(this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: const Text("Document"),
      ),
      path: path,
    );
  }
}