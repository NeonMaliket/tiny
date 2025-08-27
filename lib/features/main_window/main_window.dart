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
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ChatBloc>().add(LoadChatListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tiny')),
      floatingActionButton: _currentPage != 0
          ? AddDocumentActionButton()
          : NewChatActionButton(),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final pages = {0: ChatListPage(), 1: StoragePage()};
          return pages[index];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentPage = index;
            _pageController.jumpToPage(index);
          });
        },
        currentIndex: _currentPage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'Storage'),
        ],
      ),
    );
  }
}

class AddDocumentActionButton extends StatelessWidget {
  const AddDocumentActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Add Document',
      backgroundColor: context.theme().colorScheme.secondary,
      onPressed: () {
        context.read<DocumentBloc>().add(SelectDocumentEvent());
      },
      child: Icon(Icons.add_box),
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
