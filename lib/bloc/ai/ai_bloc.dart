import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  AiBloc() : super(AiInitial()) {
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  final SupabaseClient supabase = Supabase.instance.client;

  void _onSendMessageEvent(
    SendMessageEvent event,
    Emitter<AiState> emit,
  ) async {
    logger.debug("Sending AI message... ${event.message}");
    emit(AiMessageProcessing(event.message));
    try {
      final response = await supabase.functions.invoke(
        'ai',
        body: {
          'api_verson': event.apiVersion.name,
          'message': event.message.toMap(),
          'model': event.model,
          'chat_settings': event.chatSettings.toMap(),
        },
      );
      logger.info("AI message sent successfully");
      logger.debug("AI response: ${response.data}");
      emit(AiMessageSuccess(response.data));
    } catch (e) {
      logger.error("AI message sending error", e);
      emit(AiMessageFailure('Failed to send message to AI'));
    }
  }
}
