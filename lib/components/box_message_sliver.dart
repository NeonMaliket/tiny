import 'package:flutter/material.dart';
import 'package:tiny/components/components.dart';

class BoxMessageSliver extends StatelessWidget {
  const BoxMessageSliver({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: CyberpunkGlitch(child: Center(child: Text(message))),
      ),
    );
  }
}
