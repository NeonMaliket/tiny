import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/features/document_window/document_window.dart';
import 'package:tiny/features/features.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/chat/list',
  // initialLocation: '/chat/settings',
  routes: <RouteBase>[
    GoRoute(
      path: '/document',
      builder: (BuildContext context, GoRouterState state) {
        final metadata = state.extra as DocumentMetadata;
        logger.i('Navigating to document with ID: $metadata');
        return DocumentWindow(metadata: metadata);
      },
    ),
    GoRoute(
      path: '/chat/list',
      builder: (BuildContext context, GoRouterState state) {
        return const MainWindow();
      },
    ),
    GoRoute(
      path: '/chat/settings',
      builder: (BuildContext context, GoRouterState state) {
        return const ChatSettingsWindow();
      },
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (BuildContext context, GoRouterState state) {
        final chatId = state.pathParameters['chatId'];
        logger.i('Navigating to chat with ID: $chatId');
        return ChatWindow(chatId: chatId ?? '');
      },
    ),
  ],
);
