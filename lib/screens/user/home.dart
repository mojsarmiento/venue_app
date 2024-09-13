import 'package:flutter/material.dart';
import 'package:venue_app/screens/user/profile_page.dart';
import 'venue_catalog_screen.dart'; 
import 'bookings.dart';
import 'requests_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<String> _notifications = [
    'Your booking has been confirmed.',
    'Venue A has new availability.',
    'Reminder: Venue B visit tomorrow.',
    'Kobe Roca Pogi',
  ];

  final List<Widget> _widgetOptions = <Widget>[
    const VenueCatalogScreen(),
    const BookingsPage(),
    const RequestsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.notifications, color: Color(0xFF00008B)),
                      title: Text(_notifications[index]),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _getAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.notifications),
        color: Colors.white,
        onPressed: _showNotifications,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00008B), Color(0xFF5D3FD3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                'Welcome To Venue Vista',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: _getAppBarActions(),
            ),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00008B), Color(0xFF5D3FD3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Venues',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Bookings',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.request_page),
                    label: 'Requests',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white54,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



















