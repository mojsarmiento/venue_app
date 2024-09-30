import 'package:flutter/material.dart';
import 'package:venue_app/screens/login.dart';
import 'package:venue_app/screens/user/home.dart';
import 'package:venue_app/screens/venue_owner/owner_change_password.dart';
import 'package:venue_app/screens/venue_owner/owner_edit_profile.dart';

class VenueOwnerProfilePage extends StatelessWidget {
  const VenueOwnerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile', 
        style: TextStyle(
          color: Color(0xFF00008B),
          fontSize: 24,
          fontWeight: FontWeight.bold),
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
              backgroundImage: AssetImage(
                'assets/images/profile_pic.jpg',
              ),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 20),
            const Text(
              'Kobe Roca',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'koberoca@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerChangePasswordPage()));
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
            ElevatedButton(
              onPressed: () {
                // Implement the function to save or update profile
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00008B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to Reserver Home Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()), // Ensure this is the correct import
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00008B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Be a Reserver',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


