import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venue_app/screens/login.dart';
import 'package:venue_app/screens/user/be_a_venueowner.dart';
import 'package:venue_app/screens/user/change_password.dart';
import 'package:venue_app/screens/user/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? fullName;  // Stores user's full name
  String? email;     // Stores user's email

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Load user info on initialization
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve and update UI with values from SharedPreferences
    setState(() {
      fullName = prefs.getString('full_name') ?? 'Unknown User';
      email = prefs.getString('email') ?? 'Unknown Email';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear user data on logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Function to show the logout confirmation dialog
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(); // Perform logout
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF00008B),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 20),
            // Full name loaded dynamically from SharedPreferences
            Text(
              fullName ?? 'Loading...', 
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            // Email loaded dynamically from SharedPreferences
            Text(
              email ?? 'Loading...',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // ListTiles for different options like Edit Profile, Change Password, etc.
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF00008B)),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Color(0xFF00008B)),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.business, color: Color(0xFF00008B)),
              title: const Text('Be a Venue Owner'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BeAVenueOwnerPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Color(0xFF00008B)),
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showLogoutConfirmationDialog, // Show the logout confirmation dialog
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

