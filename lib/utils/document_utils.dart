import 'package:flutter/material.dart';

const unknownDocType = 'assets/images/documents/text.png';
final docTypeIconsMap = {
  'pdf': 'assets/images/documents/pdf.png',
  'txt': 'assets/images/documents/text.png',
};

AssetImage buildAssetImage(final String filename) {
  final type = filename.split('.').last.toLowerCase();
  final imagePath = docTypeIconsMap[type] ?? unknownDocType;
  return AssetImage(imagePath);
}
