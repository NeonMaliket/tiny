import 'package:flutter/widgets.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_doc_item.dart';
import 'package:tiny/domain/domain.dart';

typedef OnSelectDocuments =
    void Function(List<DocumentMetadata> documents);

class CyberpunkMenu extends StatelessWidget {
  const CyberpunkMenu({super.key, required this.onSelect});

  final OnSelectDocuments onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return CyberpunkDocItem(
            metadata: DocumentMetadata(
              id: index,
              filename: 'Document $index',
              type: 'txt',
              createdAt: DateTime.now(),
            ),
            onTap: () {},
          );
        },
        itemCount: 30,
      ),
    );
  }
}
