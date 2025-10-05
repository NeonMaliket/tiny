import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

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
                          (document) => _buildCyberpunkDocItem(
                            context,
                            document,
                          ),
                        )
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  CyberpunkDocItem _buildCyberpunkDocItem(
    final BuildContext context,
    final DocumentMetadata documentMetadata,
  ) {
    return CyberpunkDocItem(
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
                    'Are you sure you want to delete the document "${documentMetadata.filename}"?',
                onConfirm: (context) {
                  context.read<StorageBloc>().add(
                    DeleteDocumentEvent(metadata: documentMetadata),
                  );
                },
              ),
            );
          },
        ),
      ],
      metadata: documentMetadata,
      onTap: () {
        logger.i('Selected Document: $documentMetadata');
        context.push('/document', extra: documentMetadata);
      },
    );
  }
}
