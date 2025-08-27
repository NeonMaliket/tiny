import 'package:flutter/material.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart' as utils;

class StoragePage extends StatelessWidget {
  StoragePage({super.key});

  final documents = [
    Document(id: '1', name: 'test-1.pdf', type: 'pdf'),
    Document(id: '2', name: 'test-2.pdf', type: 'pdf'),
    Document(id: '3', name: 'test-3.pdf', type: 'pdf'),
    Document(id: '4', name: 'test-4.pdf', type: 'pdf'),
    Document(id: '5', name: 'test-5.pdf', type: 'pdf'),
    Document(id: '6', name: 'test-6.txt', type: 'txt'),
    Document(id: '7', name: 'test-7.txt', type: 'txt'),
    Document(id: '8', name: 'test-8.txt', type: 'txt'),
    Document(id: '9', name: 'test-9.pdf', type: 'pdf'),
    Document(id: '10', name: 'test-10.txt', type: 'txt'),
    Document(id: '11', name: 'test-11.txt', type: 'txt'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(10),
      crossAxisCount: 2,
      children: documents
          .map((document) => DocumentItem(document: document))
          .toList(),
    );
  }
}

class DocumentItem extends StatelessWidget {
  const DocumentItem({super.key, required this.document});

  final Document document;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: context.theme().colorScheme.secondary.withAlpha(60),
        onTap: () {
          logger.i('Selected Document: $document');
        },
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: utils.buildAssetImage(document),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: context.theme().colorScheme.secondary.withAlpha(60),
              alignment: Alignment.center,
              child: Text(
                document.name,
                style: context.theme().textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
