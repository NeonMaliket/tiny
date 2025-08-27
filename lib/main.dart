import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/tiny_application.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DocumentBloc()),
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => MessageCubit()),
      ],
      child: const TinyApplication(),
    ),
  );
}
