import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/storage_bloc/storage_bloc.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart' as utils;

class StoragePage extends StatelessWidget {
  const StoragePage({super.key, required this.documents});

  final List<DocumentMetadata> documents;

  @override
  Widget build(BuildContext context) {
    return documents.isEmpty
        ? Center(child: Text('No documents found'))
        : GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisCount: 2,
            children: documents
                .map((document) => DocumentItem(metadata: document))
                .toList(),
          );
  }
}

class DocumentItem extends StatelessWidget {
  const DocumentItem({super.key, required this.metadata});

  final DocumentMetadata metadata;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onDoubleTap: () {
          context.read<StorageBloc>().add(
            DeleteDocumentEvent(metadata: metadata),
          );
        },
        splashColor: context.theme().colorScheme.secondary.withAlpha(60),
        onTap: () {
          logger.i('Selected Document: $metadata');
          context.push('/document', extra: metadata);
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
                    image: utils.buildAssetImage(metadata),
                  ),
                ),
              ),
            ),
            Tooltip(
              message: metadata.filename,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: double.infinity,
                color: context.theme().colorScheme.secondary.withAlpha(60),
                alignment: Alignment.center,
                child: Text(
                  metadata.filename,
                  style: context.theme().textTheme.bodyLarge?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
