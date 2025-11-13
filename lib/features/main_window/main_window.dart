import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final Map<int, Chat> chats = {};
  List<StorageObject> documents = [];
  late final StreamSubscription _chatStream;
  late final StreamSubscription _storageStream;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChatListEvent());

    _chatStream = context.read<ChatBloc>().stream.listen(
      _handleChatListEvent,
    );

    _storageStream = context.read<StorageCubit>().stream.listen(
      _handleStorageEvent,
    );

    context.read<StorageCubit>().storageListFiles();

    _pageController = PageController(initialPage: _currentPage);
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
            margin: EdgeInsets.only(top: kToolbarHeight * 2),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final pages = {
                  0: ChatListPage(chats: chats.values.toList()),
                  1: StoragePage(documents: documents),
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
        HapticFeedback.mediumImpact();
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
      0: NewChatActionButton(),
      1: AddDocumentActionButton(),
    };
    return pages[_currentPage] ?? SizedBox.shrink();
  }

  void _handleStorageEvent(state) {
    if (state is StorageListSuccess) {
      setState(() {
        documents = state.storageObjects;
      });
    } else if (state is StorageUploadSuccess) {
      context.read<StorageCubit>().storageListFiles();
    } else if (state is StorageDeleteSuccess) {
      context.read<ChatBloc>().add(LoadChatListEvent());
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
    } else if (state is ChatUpdated) {
      chats[state.chat.id] = state.chat;
      setState(() {});
    }
  }
}

class NewChatActionButton extends StatelessWidget {
  const NewChatActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GlitchButton(
      chatImage: cyberpunkChatIcon,
      onClick: () {
        HapticFeedback.mediumImpact();
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
    );
  }
}

class AddDocumentActionButton extends StatelessWidget {
  const AddDocumentActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final documentCubit = context.read<DocumentCubit>();
    final storageCubit = context.read<StorageCubit>();
    return GlitchButton(
      chatImage: cyberpunkAddDocIcon,
      onClick: () async {
        HapticFeedback.mediumImpact();
        final selected = await documentCubit.selectDocument();
        if (selected != null) {
          await storageCubit.uploadStorageFile(selected);
        }
      },
    );
  }
}
