import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/user_bloc.dart';
import 'package:venue_app/bloc/user_event.dart';
import 'package:venue_app/bloc/user_state.dart';
import 'package:venue_app/models/user.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispatch the FetchUsersEvent to fetch users when the widget is built
    context.read<UserBloc>().add(FetchUsersEvent());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(
            color: Color(0xFF00008B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          // Check for UserSuccess state and show a SnackBar
          if (state is UpdateUserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message), // Display the success message
                duration: const Duration(seconds: 2), // Duration for the SnackBar
              ),
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is UserLoaded) {
              // Filter out users with userType "admin"
              final filteredUsers = state.users.where((user) {
                return user.userType != 'admin'; // Only keep users that are not admin
              }).toList();

              // Display the list of filtered users
              return ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.blueAccent),
                      title: Text(
                        user.fullName, // Display the user's full name
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${user.fullName}'),
                          Text('Email: ${user.email}'),
                          Text('User Type: ${user.userType}'), // Display the user's type
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            // Show the edit dialog
                            _showEditDialog(context, user);
                          } else if (value == 'delete') {
                            _confirmDeleteUser(context, user.userId); // Confirm before deletion
                          } else if (value == 'details') {
                            // Implement view details functionality
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('No users found.'));
          },
        ),
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<UserBloc>().add(DeleteUserEvent(userId)); // Trigger deletion
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    final formKey = GlobalKey<FormState>();
    String? fullName = user.fullName;
    String? email = user.email;
    String? userType = user.userType;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: user.fullName,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  onChanged: (value) => fullName = value,
                  validator: (value) => value!.isEmpty ? 'Enter full name' : null,
                ),
                TextFormField(
                  initialValue: user.email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) => email = value,
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                DropdownButtonFormField<String>(
                  value: user.userType,
                  decoration: const InputDecoration(labelText: 'User Type'),
                  items: <String>['reserver', 'venue_owner', 'admin'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => userType = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Create a new User instance instead of using copyWith
                  final updatedUser = User(
                    userId: user.userId,
                    fullName: fullName!,
                    email: email!,
                    userType: userType!, // Use the selected user type
                  );

                  // Dispatch the update event with the updated user
                  context.read<UserBloc>().add(UpdateUserEvent(updatedUser));
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

