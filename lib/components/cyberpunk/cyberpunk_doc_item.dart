import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart' as utils;

class CyberpunkDocItem extends StatelessWidget {
  const CyberpunkDocItem({
    super.key,
    required this.filename,
    required this.onTap,
    this.menuItems = const [],
  });

  final Function() onTap;
  final List<MenuItem> menuItems;
  final String filename;

  @override
  Widget build(BuildContext context) {
    return CyberpunkContextMenu(
      menuItems: menuItems,
      child: CyberpunkGlitch(
        child: Card(
          child: InkWell(
            splashColor: context
                .theme()
                .colorScheme
                .secondary
                .withAlpha(60),
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            child: Column(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.asset(
                    utils.buildAssetImage(filename).assetName,
                    fit: BoxFit.contain,
                    color: context
                        .theme()
                        .colorScheme
                        .accentColor
                        .withAlpha(100),
                  ),
                ),
                Tooltip(
                  message: filename,
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
                      filename,
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
