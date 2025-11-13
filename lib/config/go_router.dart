import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/features/document_window/document_window.dart';
import 'package:tiny/features/features.dart';
import 'package:tiny/repository/repository.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  navigatorKey: navigatorKey,
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
        final storageObject = state.extra as StorageObject;
        logger.i('Navigating to document: $storageObject');
        return DocumentWindow(storageObject: storageObject);
      },
    ),
    GoRoute(
      path: '/chat/list',
      builder: (BuildContext context, GoRouterState state) {
        return MainWindow();
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
            context.read<ChatBloc>(),
            getIt<StorageRepository>(),
            getIt<ChatRepository>(),
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
