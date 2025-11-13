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

  final List<StorageObject> documents;

  @override
  Widget build(BuildContext context) {
    return CyberpunkRefresh(
      onRefresh: () async {
        await context.read<StorageCubit>().storageListFiles();
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
    final StorageObject storageObject,
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
                    'Are you sure you want to delete the document "${storageObject.filename}"?',
                onConfirm: (context) async {
                  await context
                      .read<StorageCubit>()
                      .deleteStorageFile(storageObject.name);
                  if (context.mounted) {
                    await context
                        .read<StorageCubit>()
                        .storageListFiles();
                  }
                },
              ),
            );
          },
        ),
      ],
      filename: storageObject.filename,
      onTap: () {
        logger.i('Selected Document: $storageObject');
        context.push('/document', extra: storageObject);
      },
    );
  }
}
