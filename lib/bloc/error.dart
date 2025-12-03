import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: false,
      information: ['bloc=${bloc.runtimeType}'],
    );
    super.onError(bloc, error, stackTrace);
  }
}
