import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

class CyberpunkContextMenu extends StatelessWidget {
  const CyberpunkContextMenu({
    super.key,
    required this.child,
    required this.menuItems,
  });

  final List<MenuItem> menuItems;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: ContextMenu(entries: menuItems),
      child: child,
    );
  }
}
