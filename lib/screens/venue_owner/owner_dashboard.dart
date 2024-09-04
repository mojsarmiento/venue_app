import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.book_online, color: Color(0xFF00008B)),
                title: Text('Total Reservations'),
                subtitle: Text('15'), // Replace with actual data
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.monetization_on, color: Color(0xFF00008B)),
                title: Text('Total Earnings'),
                subtitle: Text('₱30,000'), // Replace with actual data
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.house, color: Color(0xFF00008B)),
                title: Text('Total Venues'),
                subtitle: Text('5'), // Replace with actual data
              ),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.message, color: Color(0xFF00008B)),
                title: Text('Total Request Visits'),
                subtitle: Text('5'), // Replace with actual data
              ),
            ),
          ],
        ),
      ),
    );
  }
}

