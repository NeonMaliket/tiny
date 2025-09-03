import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/features/main_window/pages/pages.dart';
import 'package:tiny/theme/theme.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(LoadChatListEvent());
    return Scaffold(
      appBar: _appBar(context),
      extendBodyBehindAppBar: true,
      floatingActionButton: _buildFloatingActionButton(),
      body: Container(
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
              0: ChatListPage(),
              1: StoragePage(),
              2: SettingsPage(),
            };
            return pages[index];
          },
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
}

class AddDocumentActionButton extends StatelessWidget {
  const AddDocumentActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentBloc, DocumentState>(
      listener: (context, state) async {
        if (state is DocumentSelected) {
          await context.read<StorageCubit>().uploadDocumentEvent(
            filename: state.file.path.split('/').last,
            file: state.file,
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
