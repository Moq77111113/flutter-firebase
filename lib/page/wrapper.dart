import 'package:flutter/material.dart';
import 'package:myapp/page/stopwatch.dart';
import 'package:myapp/provider/notifications_service.dart';
import 'package:myapp/widgets/drawer.dart';
import 'package:myapp/widgets/home.dart';
import 'package:myapp/provider/google_auth.dart';
import 'package:myapp/widgets/results.dart';
import 'package:provider/provider.dart';

enum Pages { tabs, stopWatch, about, info }

class WrapperPage extends StatefulWidget {
  const WrapperPage({Key? key, title}) : super(key: key);

  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  int selectedIndex = 0;
  Pages activePage = Pages.tabs;

  String title = 'My application';

  @override
  void initState() {
    Provider.of<NotificationService>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          title: Text(title),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                child: const Text('Logout'))
          ],
        ),
        body: getBody(),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            setState(() {
              activePage = Pages.stopWatch;
            });
          },
          child: const Icon(Icons.watch_outlined),
          backgroundColor: Colors.white,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: // sets the inactive color of the `BottomNavigationBar`

            BottomNavigationBar(
                selectedItemColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list), label: 'Results')
                ],
                onTap: (int index) {
                  onTapHandler(index);
                }),
        drawer: const MenuWidget());
  }

  Widget getBody() {
    switch (activePage) {
      case Pages.tabs:
        switch (selectedIndex) {
          case 0:
            {
              title = 'Home';
              return const HomeWidget();
            }
          case 1:
            {
              title = 'Result';
              return const Result();
            }
          default:
            {
              title = 'Home';
              return const HomeWidget();
            }
        }
      case Pages.stopWatch:
        {
          title = 'StopWatch';
          return const StopWatchPage();
        }
      case Pages.about:
        {
          title = 'About';
          return const Center(child: Text('About'));
        }
      case Pages.info:
        {
          title = 'Informations';
          return const Center(child: Text('Informations'));
        }
    }
  }

  void onTapHandler(int index) {
    setState(() {
      activePage = Pages.tabs;
      selectedIndex = index;
    });
  }
}
