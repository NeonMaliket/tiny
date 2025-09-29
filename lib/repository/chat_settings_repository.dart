import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';

class ChatSettingsRepository {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<void> updateChatSettings(ChatSettings settings) async {
    await supabaseClient
        .from('chat_settings')
        .update(settings.toMap())
        .eq('chat_id', settings.chatId);
  }

  Future<ChatSettings> getChatSettings(int chatId) async {
    final response = await supabaseClient
        .from('chat_settings')
        .select()
        .eq('chat_id', chatId)
        .single();
    return ChatSettings.fromMap(response);
  }
}
