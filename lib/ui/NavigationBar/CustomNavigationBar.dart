import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Calendar/Calendar.dart';
import '../Todo/Todo.dart';
import '../Profile/ProfilePage.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CustomNavigationBar> {
  int _currentIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final navigator = _navigatorKeys[_currentIndex].currentState;
        if (navigator?.canPop() ?? false) {
          navigator!.pop();
        } else {
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildNavigator(0, const Calendar()),
            _buildNavigator(1, const Todo()),
            _buildNavigator(2, const ProfilePage()),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildNavigator(int index, Widget screen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute:
          (settings) => MaterialPageRoute(
            builder: (_) => settings.name == '/' ? screen : _errorScreen(),
          ),
    );
  }

  Widget _errorScreen() => const Center(child: Text('Page not found'));

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Todo'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
