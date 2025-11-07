import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/features/document_window/document_window.dart';
import 'package:tiny/features/features.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginWindow();
      },
    ),
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
        return const CyberpunkLoaderDecorator(child: MainWindow());
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (BuildContext context, GoRouterState state) {
        final chat = state.extra as Chat;
        logger.i('Navigating to chat with ID: ${chat.id}');
        return BlocProvider(
          create: (BuildContext context) => ChatCubit(
            chat,
            context.read<CyberpunkAlertBloc>(),
            context.read<ChatBloc>(),
            context.read<ChatDocumentBloc>(),
          ),
          child: ChatWindow(),
        );
      },
      routes: [
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            final chatCubit = state.extra as ChatCubit;
            return BlocProvider.value(
              value: chatCubit,
              child: const ChatSettingsWindow(),
            );
          },
        ),
      ],
    ),
  ],
);
