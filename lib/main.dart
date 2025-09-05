import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/repository/repository.dart';
import 'package:tiny/tiny_application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AlertBloc()),
        BlocProvider(create: (_) => DocumentBloc()),
        BlocProvider(
          create: (_) =>
              StorageBloc(storageRepository: getIt<StorageRepository>()),
        ),
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => MessageCubit()),
      ],
      child: const TinyApplication(),
    ),
  );
}
