import 'package:flutter/material.dart';
import 'package:tiny/theme/theme.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tiny')),
      body: Column(
        children: [
          Expanded(flex: 8, child: Center(child: Text('Empty chat'))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 40),
            child: TextField(
              maxLines: 10,
              minLines: 1,
              decoration: InputDecoration(
                labelText: 'User Message',
                alignLabelWithHint: true,
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 21,
                          color: context.theme().colorScheme.secondary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
