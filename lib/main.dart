import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/bloc/record/record_bloc.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/tiny_application.dart';

import 'repository/repository.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeFirebase();
      await dotenv.load(fileName: '.env');
      await supabase();
      setupLocator();
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LoaderCubit()),
            BlocProvider(create: (_) => CyberpunkAlertBloc()),
            BlocProvider(create: (_) => AiBloc()),
            BlocProvider(create: (_) => DocumentCubit()),
            BlocProvider(
              create: (_) =>
                  RecordBloc(storage: getIt<StorageRepository>()),
            ),
            BlocProvider(
              create: (ctx) => StorageCubit(
                getIt<StorageRepository>(),
                ctx.read<LoaderCubit>(),
              ),
            ),
            BlocProvider(create: (ctx) => ChatBloc()),
            BlocProvider(
              create: (ctx) => ContextDocumentsCubit(
                contextDocumentsRepository:
                    getIt<ContextDocumentsRepository>(),
              ),
            ),
            BlocProvider(create: (ctx) => MessageCubit()),
          ],
          child: const TinyApplication(),
        ),
      );
    },
    (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      logger.error('Uncaught error: ', error, stackTrace);
    },
  );
}
