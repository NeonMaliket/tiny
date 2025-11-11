import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/tiny_application.dart';

import 'repository/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await supabase();
  setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoaderCubit()),
        BlocProvider(create: (_) => CyberpunkAlertBloc()),
        BlocProvider(create: (_) => DocumentCubit()),
        BlocProvider(
          create: (ctx) => StorageCubit(getIt<StorageRepository>()),
        ),
        BlocProvider(create: (ctx) => ChatBloc()),
        BlocProvider(
          create: (ctx) => MessageCubit(
            cyberpunkAlertBloc: ctx.read<CyberpunkAlertBloc>(),
          ),
        ),
      ],
      child: const TinyApplication(),
    ),
  );
}
