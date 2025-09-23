import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkSettingsTile extends AbstractSettingsTile {
  const CyberpunkSettingsTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onToggle,
  });

  final String title;
  final Icon leadingIcon;
  final GestureTapCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return CustomSettingsTile(
      child: ListTile(
        title: Text(title, style: context.theme().textTheme.titleSmall),
        shape: cyberpunkShape(
          cyberpunkBorderSide(
            context,
            context.theme().colorScheme.secondary,
          ).copyWith(width: 0.3),
        ),
        leading: leadingIcon,
        onTap: onToggle,
      ),
    );
  }
}
