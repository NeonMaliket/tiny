import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart' as utils;

class StoragePage extends StatelessWidget {
  const StoragePage({super.key, required this.documents});

  final List<DocumentMetadata> documents;

  @override
  Widget build(BuildContext context) {
    documents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return CyberpunkRefresh(
      onRefresh: () async {
        documents.clear();
        context.read<StorageBloc>().add(StreamStorageEvent());
      },
      child: CustomScrollView(
        slivers: [
          documents.isEmpty
              ? BoxMessageSliver(message: 'No documents found')
              : SliverToBoxAdapter(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    crossAxisCount: 2,
                    children: documents
                        .map(
                          (document) =>
                              DocumentItem(metadata: document),
                        )
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }
}

class DocumentItem extends StatelessWidget {
  const DocumentItem({super.key, required this.metadata});

  final DocumentMetadata metadata;

  @override
  Widget build(BuildContext context) {
    return CyberpunkContextMenu(
      menuItems: [
        MenuItem(
          color: context.theme().primaryColor,
          label: 'Delete',
          value: "Delete",
          icon: Icons.delete,
          onSelected: () {
            context.read<CyberpunkAlertBloc>().add(
              ShowCyberpunkAlertEvent(
                type: CyberpunkAlertType.info,
                title: 'Delete Document',
                message:
                    'Are you sure you want to delete the document "${metadata.filename}"?',
                onConfirm: (context) {
                  context.read<StorageBloc>().add(
                    DeleteDocumentEvent(metadata: metadata),
                  );
                },
              ),
            );
          },
        ),
      ],
      child: CyberpunkGlitch(
        child: Card(
          child: InkWell(
            splashColor: context
                .theme()
                .colorScheme
                .secondary
                .withAlpha(60),
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
                  child: Image.asset(
                    utils.buildAssetImage(metadata).assetName,
                    fit: BoxFit.contain,
                    color: context
                        .theme()
                        .colorScheme
                        .accentColor
                        .withAlpha(100),
                  ),
                ),
                Tooltip(
                  message: metadata.filename,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    color: context
                        .theme()
                        .colorScheme
                        .secondary
                        .withAlpha(60),
                    alignment: Alignment.center,
                    child: Text(
                      metadata.filename,
                      style: context
                          .theme()
                          .textTheme
                          .bodyLarge
                          ?.copyWith(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
