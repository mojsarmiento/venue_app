import 'package:flutter/material.dart';
import 'package:venue_app/screens/admin/admin_change_password.dart';
import 'package:venue_app/screens/admin/admin_edit_profile.dart';
import 'package:venue_app/screens/login.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key, required String fullName, required String email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile', 
        style: TextStyle(
          color:Color(0xFF00008B),
          fontSize: 24,
          fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                'assets/images/profile_pic.jpg',
              ),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 20),
            const Text(
              'Venue Vista',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'venuevistaadmin@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.lock, color: Color(0xFF00008B)),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminChangePasswordPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Color(0xFF00008B)),
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}