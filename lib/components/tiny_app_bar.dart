import 'package:flutter/material.dart';

class TinyAppBar extends AppBar {
  TinyAppBar({super.key, required this.onLeading});

  final Function() onLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Tiny'),
      leading: IconButton(onPressed: onLeading, icon: Icon(Icons.arrow_back)),
    );
  }
}
