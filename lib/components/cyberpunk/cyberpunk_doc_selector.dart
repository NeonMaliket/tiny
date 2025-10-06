import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

typedef OnSelectDocuments =
    void Function(List<DocumentMetadata> documents);

class CyberpunkMenu extends StatefulWidget {
  const CyberpunkMenu({super.key, required this.onSelect});

  final OnSelectDocuments onSelect;

  @override
  State<CyberpunkMenu> createState() => _CyberpunkMenuState();
}

class _CyberpunkMenuState extends State<CyberpunkMenu> {
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
      child: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          final docIconColor = _isSelected(document)
              ? context.theme().colorScheme.primary
              : context.theme().colorScheme.error;
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.063,
            child: CyberpunkGlitch(
              isEnabled: _isSelected(document),
              child: ListTile(
                onTap: () => _onSelect(document),
                leading: AspectRatio(
                  aspectRatio: 0.7,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: docIconColor.withAlpha(50),
                      shape: BeveledRectangleBorder(
                        side: cyberpunkBorderSide(
                          context,
                          color: docIconColor,
                          width: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                title: Text(document.filename),
              ),
            ),
          );
        },
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
