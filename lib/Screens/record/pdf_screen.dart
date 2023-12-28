// ignore_for_file: avoid_print, library_private_types_in_public_api, unused_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import from flutter_pdfview

class PDFScreen extends StatefulWidget {
  final String path;

  const PDFScreen(this.path, {super.key});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  //int _pageNumber = 1;
  bool _pdfReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.path,
           // pageNumber: _pageNumber,
            onPageChanged: (page, totalPages) {
              setState(() {
               // _pageNumber = page!;
                _pdfReady = true;
              });
            },
          ),
          if (!_pdfReady)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
