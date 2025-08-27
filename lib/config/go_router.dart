import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/features/main_window/main_window.dart';
import 'package:tiny/features/chat_window/chat_window.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/chat/list',
  routes: <RouteBase>[
    GoRoute(
      path: '/chat/list',
      builder: (BuildContext context, GoRouterState state) {
        return const MainWindow();
      },
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (BuildContext context, GoRouterState state) {
        final chatId = state.pathParameters['chatId'];
        logger.i('Navigating to chat with ID: $chatId');
        return ChatWindow(chatId: chatId ?? '');
      },
      pageBuilder: GoTransitions.fadeUpwards
          .withSettings(duration: Duration(milliseconds: 500))
          .build(),
    ),
  ],
);
