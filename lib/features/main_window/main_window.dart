import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/features/main_window/pages/pages.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late final PageController _pageController;
  int _currentPage = 0;

  final List<SimpleChat> chats = [];
  final List<DocumentMetadata> documents = [];
  late final StreamSubscription _chatStream;
  late final StreamSubscription _storageStream;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChatListEvent());
    context.read<StorageBloc>().add(StreamStorageEvent());

    _chatStream = context.read<ChatBloc>().stream.listen(_handleChatListEvent);
    _storageStream = context.read<StorageBloc>().stream.listen(
      _onStorageLoaded,
    );

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
      appBar: _appBar(context),
      extendBodyBehindAppBar: true,
      floatingActionButton: _buildFloatingActionButton(),
      body: AlertDecorator(
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
                0: ChatListPage(chats: chats),
                1: StoragePage(documents: documents),
                2: SettingsPage(),
              };
              return pages[index];
            },
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            color: context.theme().colorScheme.secondary.withAlpha(10),
          ),
        ),
      ),
      title: Text('Tiny'),
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
          icon: Icon(CupertinoIcons.chat_bubble_2_fill),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.doc_fill),
          label: 'Storage',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    final pages = {0: NewChatActionButton(), 1: AddDocumentActionButton()};
    return pages[_currentPage] ?? SizedBox.shrink();
  }

  void _onStorageLoaded(state) {
    if (state is StorageDocumentRecived) {
      final streamEvent = state.event.event;

      switch (streamEvent) {
        case StreamEventType.newInstance:
        case StreamEventType.history:
          if (state.event.data != null) {
            final metadata = DocumentMetadata.fromJson(state.event.data!);
            documents.add(metadata);
          }
        case StreamEventType.delete:
          if (state.event.data != null) {
            final data = EntityBase.fromJson(state.event.data!);
            documents.removeWhere((doc) => doc.id == data.id);
          }
        default:
          return;
      }
      setState(() {});
    }
  }

  void _handleChatListEvent(state) {
    if (state is ChatListItemReceived) {
      setState(() {
        final streamEvent = state.event;
        switch (streamEvent.event) {
          case StreamEventType.history:
          case StreamEventType.newInstance:
            if (streamEvent.data != null) {
              final chat = SimpleChat.fromJson(streamEvent.data!);
              chats.add(chat);
            }
            break;
          case StreamEventType.delete:
            if (streamEvent.data != null) {
              final chatId = EntityBase.fromJson(streamEvent.data!).id;
              chats.removeWhere((chat) => chat.id == chatId);
            }
            break;
          default:
            break;
        }
        setState(() {});
      });
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
      child: FloatingActionButton(
        tooltip: 'Add Document',
        onPressed: () {
          context.read<DocumentBloc>().add(SelectDocumentEvent());
        },
        child: Icon(Icons.add_box),
      ),
    );
  }
}

class NewChatActionButton extends StatelessWidget {
  const NewChatActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => NewChatAlertDialog(),
        );
      },
      child: Icon(Icons.chat),
    );
  }
}
