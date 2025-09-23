import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkSettingsToggle extends AbstractSettingsTile {
  const CyberpunkSettingsToggle({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
  });

  final String title;
  final Icon leadingIcon;
  final ValueChanged<bool>? onTap;

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
        trailing: _CustomSwitch(
          value: false,
          onChanged: (bool value) {
            if (onTap != null) {
              onTap!(value);
            }
          },
          activeColor: context.theme().colorScheme.secondary,
        ),
      ),
    );
  }
}

class _CustomSwitch extends StatefulWidget {
  const _CustomSwitch({
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  @override
  State<_CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<_CustomSwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (bool newValue) {
        setState(() {
          value = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
