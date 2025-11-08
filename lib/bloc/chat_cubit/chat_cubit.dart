import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

typedef _AlertBloc = Bloc<CyberpunkAlertEvent, CyberpunkAlertState>;

class ChatCubit extends Cubit<Chat> {
  ChatCubit(
    this._chat,
    this._cyberpunkAlertBloc,
    this._chatBloc,
    this._chatDocumentBloc,
  ) : super(_chat) {
    getIt<ChatDocumentsRepository>().loadRagDocuments(_chat.id).then((
      documents,
    ) {
      emit(state.copyWith(rag: documents));
    });
    _chatDocSub = _chatDocumentBloc.stream.listen((
      chatDocumentState,
    ) {
      if (chatDocumentState is DocumentConnectedState &&
          chatDocumentState.chatId == _chat.id) {
        state.rag.add(chatDocumentState.document);
      } else if (chatDocumentState is DocumentDisconnectedState &&
          chatDocumentState.chatId == _chat.id) {
        state.rag.removeWhere(
          (doc) => doc.id == chatDocumentState.documentId,
        );
      }
    });
  }

  final Chat _chat;
  final _AlertBloc _cyberpunkAlertBloc;
  final ChatBloc _chatBloc;
  final ChatDocumentBloc _chatDocumentBloc;
  late final StreamSubscription _chatDocSub;

  @override
  Future<void> close() async {
    await _chatDocSub.cancel();
    return super.close();
  }

  Future<ChatSettings> updateChatSettings(
    final ChatSettings newSettings,
  ) async {
    try {
      final response = await getIt<ChatSettingsRepository>()
          .updateChatSettings(_chat.id, newSettings);
      emit(state.copyWith(settings: response));
      _chatBloc.add(UpdateChatEvent(chat: state));
    } catch (e) {
      logger.e("Error: ", error: e);
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to update chat settings',
        ),
      );
    }
    return state.settings;
  }

  Future<DocumentMetadata?> updateAvatar(File picture) async {
    try {
      final chatStorageRepository = getIt<ChatStorageRepository>();
      final metadata = await chatStorageRepository.uploadChatFile(
        chatId: _chat.id,
        filename: picture.path.split('/').last,
        file: picture,
      );
      await getIt<ChatRepository>().updateChatAvatar(
        chatId: _chat.id,
        avatarMetadata: metadata,
      );
      emit(state.copyWith(avatarMetadata: metadata));
      _chatBloc.add(UpdateChatEvent(chat: state));
    } catch (e) {
      logger.e("Error: ", error: e);
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to update chat avatar',
        ),
      );
    }
    return state.avatarMetadata;
  }
}
