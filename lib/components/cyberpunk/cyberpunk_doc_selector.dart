import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

typedef OnSelectDocuments =
    void Function(List<DocumentMetadata> documents);

class CyberpunkDocSelector extends StatefulWidget {
  const CyberpunkDocSelector({super.key, required this.onSelect});

  final OnSelectDocuments onSelect;

  @override
  State<CyberpunkDocSelector> createState() =>
      _CyberpunkDocSelectorState();
}

class _CyberpunkDocSelectorState extends State<CyberpunkDocSelector> {
  final List<DocumentMetadata> documents = [];
  final Map<int, DocumentMetadata> selected = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<StorageBloc>().add(StreamStorageEvent());
    context.read<StorageBloc>().stream.listen((state) {
      if (state is StorageDocumentRecived) {
        documents.add(state.metadata);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CyberpunkBackground(
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
            delegate: SliverChildBuilderDelegate((context, index) {
              final document = documents[index];
              final docIconColor = _isSelected(document)
                  ? context.theme().colorScheme.primary
                  : context.theme().colorScheme.error;

              return SizedBox(
                height: 50,
                child: CyberpunkGlitch(
                  chance: 100,
                  isEnabled: _isSelected(document),
                  child: Tooltip(
                    message: document.filename,
                    child: ListTile(
                      leading: Icon(
                        Icons.insert_drive_file,
                        color: docIconColor,
                      ),
                      onTap: () => _onSelect(document),
                      title: Text(
                        document.filename,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: documents.length),
          ),
        ],
      ),
    );
  }

  bool _isSelected(DocumentMetadata document) {
    return selected.containsKey(document.id);
  }

  void _onSelect(DocumentMetadata document) {
    if (selected.containsKey(document.id)) {
      selected.remove(document.id);
    } else {
      final id = document.id;
      if (id != null) {
        selected[id] = document;
      }
    }
    widget.onSelect(selected.values.toList());
    print(selected);
    setState(() {});
  }
}
