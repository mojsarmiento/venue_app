import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'Kobe Roca');
  final _emailController = TextEditingController(text: 'koberoca@gmail.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF00008B),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00008B)),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Removed CircleAvatar and related IconButton
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Color(0xFF00008B)),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFF00008B)),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Implement save functionality
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
            ],
          ),
        ),
      ),
    );
  }
}
