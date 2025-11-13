import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/context_documents/context_documents_cubit.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkDocSelector extends StatefulWidget {
  const CyberpunkDocSelector({
    super.key,
    required this.chat,
    required this.documents,
  });

  final Chat chat;
  final List<StorageObject> documents;

  @override
  State<CyberpunkDocSelector> createState() =>
      _CyberpunkDocSelectorState();
}

class _CyberpunkDocSelectorState extends State<CyberpunkDocSelector> {
  late List<StorageObject> selected;

  @override
  void initState() {
    super.initState();
    selected = widget.chat.rag;
  }

  @override
  Widget build(BuildContext context) {
    return CyberpunkBackground(
      child:
          BlocListener<ContextDocumentsCubit, ContextDocumentsState>(
            listener: _listenContextDocuments,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    'RAG Documents (${selected.length})',
                    style: context.theme().textTheme.titleMedium,
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((
                    context,
                    index,
                  ) {
                    final document = widget.documents[index];
                    final docIconColor = _isSelected(document)
                        ? context.theme().colorScheme.primary
                        : context.theme().colorScheme.error;
                    final isSelected = _isSelected(document);
                    return SizedBox(
                      height: 50,
                      child: CyberpunkGlitch(
                        chance: 100,
                        isEnabled: isSelected,
                        child: Tooltip(
                          message: document.filename,
                          child: ListTile(
                            leading: Icon(
                              Icons.insert_drive_file,
                              color: docIconColor,
                            ),
                            onTap: () => _onTap(isSelected, document),
                            title: Text(
                              document.filename,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  }, childCount: widget.documents.length),
                ),
              ],
            ),
          ),
    );
  }

  void _listenContextDocuments(
    BuildContext context,
    ContextDocumentsState state,
  ) {
    if (state is ContextDocumentAdded) {
      setState(() {
        selected.add(state.document);
      });
    }
    if (state is ContextDocumentRemoved) {
      setState(() {
        selected.removeWhere((doc) => doc.id == state.document.id);
      });
    }
  }

  void _onTap(bool isSelected, StorageObject document) {
    if (isSelected) {
      context.read<ContextDocumentsCubit>().removeContextDocument(
        chatId: widget.chat.id,
        document: document,
      );
    } else {
      context.read<ContextDocumentsCubit>().addContextDocument(
        chatId: widget.chat.id,
        document: document,
      );
    }
  }

  bool _isSelected(StorageObject storageObgect) {
    return selected
        .where((doc) => doc.id == storageObgect.id)
        .isNotEmpty;
  }
}
