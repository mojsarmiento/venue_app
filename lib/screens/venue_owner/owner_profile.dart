import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venue_app/screens/login.dart';  
import 'package:venue_app/screens/user/change_password.dart';
import 'package:venue_app/screens/user/home.dart';
import 'package:venue_app/screens/venue_owner/owner_edit_profile.dart';

class VenueOwnerProfilePage extends StatefulWidget {
  const VenueOwnerProfilePage({super.key});

  @override
  _VenueOwnerProfilePageState createState() => _VenueOwnerProfilePageState();
}

class _VenueOwnerProfilePageState extends State<VenueOwnerProfilePage> {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerEditProfilePage()));
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
              title: const Text('Be a Reserver'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Color(0xFF00008B)),
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showLogoutConfirmationDialog, // Trigger the logout function
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}



