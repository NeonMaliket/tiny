import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/features/main_window/pages/pages.dart';
import 'package:tiny/theme/theme_icons.dart';
import 'package:tiny/utils/utils.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late final PageController _pageController;
  int _currentPage = 0;

  final Map<int, SimpleChat> chats = {};
  final Map<int, DocumentMetadata> documents = {};
  late final StreamSubscription _chatStream;
  late final StreamSubscription _storageStream;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChatListEvent());
    context.read<StorageBloc>().add(StreamStorageEvent());

    _chatStream = context.read<ChatBloc>().stream.listen(
      _handleChatListEvent,
    );
    _storageStream = context
        .read<StorageBloc>()
        .stream
        .listen(_onStorageLoaded);

    _pageController = PageController(
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _chatStream.cancel();
    _storageStream.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      extendBodyBehindAppBar: true,
      floatingActionButton: _buildFloatingActionButton(),
      body: CyberpunkAlertDecorator(
        child: CyberpunkBackground(
          child: Container(
            margin: EdgeInsets.only(
              top: kToolbarHeight * 2,
            ),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final pages = {
                  0: ChatListPage(
                    chats: chats.values.toList(),
                  ),
                  1: StoragePage(
                    documents: documents.values.toList(),
                  ),
                  2: SettingsPage(),
                };
                return pages[index];
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  BottomNavigationBar _bottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      onTap: (index) {
        setState(() {
          _currentPage = index;
          _pageController.jumpToPage(index);
        });
      },
      currentIndex: _currentPage,
      items: [
        BottomNavigationBarItem(
          icon: CyberpunkIcon(
            glitching: _currentPage == 0,
            icon: CupertinoIcons.chat_bubble_2_fill,
          ),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: CyberpunkIcon(
            glitching: _currentPage == 1,
            icon: CupertinoIcons.doc_fill,
          ),
          label: 'Storage',
        ),
        BottomNavigationBarItem(
          icon: CyberpunkIcon(
            glitching: _currentPage == 2,
            icon: CupertinoIcons.settings,
          ),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    final pages = {
      0: GlitchButton(
        chatImage: cyberpunkChatIcon,
        onClick: () {
          showDialog(
            context: context,
            builder: (context) {
              return CyberpunkModal(
                title: 'New Chat',
                onClose: (context, controller) {
                  Navigator.of(context).pop();
                },
                onConfirm: (context, controller) {
                  final title = controller.text;
                  context.read<ChatBloc>().add(
                    NewChatEvent(title: title),
                  );
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
      ),
      1: AddDocumentActionButton(),
    };
    return pages[_currentPage] ?? SizedBox.shrink();
  }

  void _onStorageLoaded(state) {
    if (state is StorageDocumentRecived ||
        state is DocumentUploaded) {
      final metadata = state.metadata;
      documents[metadata.id!] = metadata;
      setState(() {});
    } else if (state is StorageDocumentDeleted) {
      final docMetadataId = state.docMetadataId;
      documents.remove(docMetadataId);
      setState(() {});
    }
  }

  void _handleChatListEvent(state) {
    if (state is ChatListItemReceived) {
      chats[state.chat.id] = state.chat;
      setState(() {});
    } else if (state is ChatDeleted) {
      chats.remove(state.chatId);
      setState(() {});
    } else if (state is NewChatCreated) {
      chats[state.chat.id] = state.chat;
      setState(() {});
    }
  }
}

class AddDocumentActionButton extends StatelessWidget {
  const AddDocumentActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state is DocumentSelected) {
          context.read<StorageBloc>().add(
            UploadDocumentEvent(
              filename: state.file.path.split('/').last,
              file: state.file,
            ),
          );
        }
      },
      child: GlitchButton(
        chatImage: cyberpunkAddDocIcon,
        onClick: () {
          context.read<DocumentBloc>().add(
            SelectDocumentEvent(),
          );
        },
      ),
    );
  }
}
