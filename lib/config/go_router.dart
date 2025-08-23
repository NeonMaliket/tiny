import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/features/chat_list/chat_list.dart';
import 'package:tiny/features/chat_window/chat_window.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/chat/list',
  routes: <RouteBase>[
    GoRoute(
      path: '/chat/list',
      builder: (BuildContext context, GoRouterState state) {
        return const ChatListWindow();
      },
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (BuildContext context, GoRouterState state) {
        final chatId = state.pathParameters['chatId'];
        logger.i('Navigating to chat with ID: $chatId');
        return ChatWindow(chatId: chatId ?? '');
      },
      pageBuilder: GoTransitions.fade
          .withSettings(duration: Duration(milliseconds: 700))
          .call,
    ),
  ],
);
