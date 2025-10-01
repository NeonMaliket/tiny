import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';

class ChatSettingsRepository {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<void> updateChatSettings(int chatId, ChatSettings settings) async {
    await supabaseClient
        .from('chats')
        .update({'settings': settings.toMap()})
        .eq('id', chatId);
  }

  Future<ChatSettings> getChatSettings(int chatId) async {
    final response = await supabaseClient
        .from('chats')
        .select('settings')
        .eq('id', chatId)
        .single();
    return ChatSettings.fromMap(response);
  }
}
