import 'package:flutter/material.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/features/document_window/doc_preview.dart';

class DocumentWindow extends StatelessWidget {
  const DocumentWindow({super.key, required this.metadata});

  final DocumentMetadata metadata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiny'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: DocPreview(metadata: metadata),
    );
  }
}
