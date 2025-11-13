import 'package:flutter/material.dart';
import 'package:tiny/config/go_router.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/features/document_window/doc_preview.dart';

class DocumentWindow extends StatelessWidget {
  const DocumentWindow({super.key, required this.storageObject});

  final StorageObject storageObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiny'),
        leading: IconButton(
          onPressed: () => navigatorKey.currentState?.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: DocPreview(path: storageObject.name),
    );
  }
}
