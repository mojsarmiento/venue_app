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
  String _fullName = 'Loading...'; // Placeholder for full name
  String _email = 'Loading...'; // Placeholder for email

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Load user info on initialization
  }

  Future<void> _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Retrieve full name and email from SharedPreferences
    String? fullName = prefs.getString('full_name'); 
    String? email = prefs.getString('email'); 

    // Debugging output to check values
    print('Loaded Full Name: $fullName');
    print('Loaded Email: $email');

    setState(() {
      // Update UI with retrieved values or fallback to defaults
      _fullName = fullName ?? 'Unknown User'; 
      _email = email ?? 'Unknown Email'; 
    });
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved user info on logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
            Text(
              _fullName, // User's full name loaded dynamically
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _email, // User's email loaded dynamically
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // ListTile for navigating to different functionalities
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
              onTap: _logout, // Trigger the logout function
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}


