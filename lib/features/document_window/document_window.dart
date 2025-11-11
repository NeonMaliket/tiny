import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/features/document_window/doc_preview.dart';

class DocumentWindow extends StatelessWidget {
  const DocumentWindow({super.key, required this.filename});

  final String filename;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiny'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: DocPreview(filename: filename),
    );
  }
}
