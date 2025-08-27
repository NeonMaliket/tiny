import 'package:flutter/material.dart';
import 'package:tiny/domain/domain.dart';

const unknownDocType = 'assets/images/documents/text.png';
final docTypeIconsMap = {
  'pdf': 'assets/images/documents/pdf.png',
  'txt': 'assets/images/documents/text.png',
};

AssetImage buildAssetImage(final Document doc) {
  final imagePath = docTypeIconsMap[doc.type] ?? unknownDocType;
  return AssetImage(imagePath);
}
