import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseUrl = dotenv.env['PUBLIC_SUPABASE_URL'];
final supabaseAnonKey = dotenv.env['PUBLIC_SUPABASE_ANON_KEY'];

supabase() async {
  await Supabase.initialize(
    url: supabaseUrl!,
    anonKey: supabaseAnonKey!,
  );
}
