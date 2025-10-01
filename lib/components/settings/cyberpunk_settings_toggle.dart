import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkSettingsToggle extends AbstractSettingsTile {
  const CyberpunkSettingsToggle({
    super.key,
    required this.leadingIcon,
    required this.initialValue,
    required this.title,
    required this.onTap,
  });

  final bool initialValue;
  final String title;
  final Icon leadingIcon;
  final ValueChanged<bool>? onTap;

  @override
  Widget build(BuildContext context) {
    print('TOGGLE: $initialValue');
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
          initialValue: initialValue,
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
    required this.onChanged,
    this.activeColor,
    required this.initialValue,
  });

  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final bool initialValue;

  @override
  State<_CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<_CustomSwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (bool newValue) {
        setState(() {
          value = newValue;
          widget.onChanged(newValue);
        });
      },
    );
  }
}
