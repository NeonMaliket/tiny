import 'package:flutter/material.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkDocSelector extends StatefulWidget {
  const CyberpunkDocSelector({
    super.key,
    required this.chatId,
    required this.rag,
  });

  final int chatId;
  final List<String> rag;

  @override
  State<CyberpunkDocSelector> createState() =>
      _CyberpunkDocSelectorState();
}

class _CyberpunkDocSelectorState extends State<CyberpunkDocSelector> {
  late final List<String> documents = [];
  late final List<String> selected = [];

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
                    message: document,
                    child: ListTile(
                      leading: Icon(
                        Icons.insert_drive_file,
                        color: docIconColor,
                      ),
                      onTap: () => print('Open Document $document'),
                      title: Text(
                        document,
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

  bool _isSelected(String filename) {
    return selected.contains(filename);
  }
}
