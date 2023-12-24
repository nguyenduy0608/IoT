import 'package:first_app/lich.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';

import 'bosung.dart';
import 'history.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const NavigationRailExampleApp();
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),

  ));
}

class NavigationRailExampleApp extends StatelessWidget {
  const NavigationRailExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NavRailExample(),
    );
  }
}

class NavRailExample extends StatefulWidget {
  const NavRailExample({Key? key}) : super(key: key);

  @override
  State<NavRailExample> createState() => _NavRailExampleState();
}

class _NavRailExampleState extends State<NavRailExample> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  double groupAlignment = -1.0;

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button to dismiss the dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Đăng Xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: const Text('Có'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Đóng dialog
                // TODO: Xử lý khi người dùng chọn "Có", ví dụ: chuyển đến trang đăng nhập.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giám sát chất lượng nước'),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: groupAlignment,
            onDestinationSelected: (int index) {
              if (index == 3) {
                // Người dùng nhấp vào "History", hiển thị hộp thoại cảnh báo đăng xuất.
                _showLogoutConfirmationDialog(context);
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            labelType: labelType,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_filled),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.book),
                label: Text('History'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(Icons.star),
                label: Text('Help'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_applications),
                selectedIcon: Icon(Icons.settings_applications),
                label: Text('Log out'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                Date(),
                // Content for History
                HistoryContent(),

                // Content for Help
                Center(
                  child: Bosung(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

