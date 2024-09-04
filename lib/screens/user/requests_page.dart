import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> requests = [
      {
        'venue': 'Venue A',
        'date': 'Aug 20, 2024',
        'time': '10:00 AM - 12:00 PM',
        'status': 'Approved',
      },
      {
        'venue': 'Venue B',
        'date': 'Aug 21, 2024',
        'time': '1:00 PM - 3:00 PM',
        'status': 'Pending',
      },
      {
        'venue': 'Venue C',
        'date': 'Aug 22, 2024',
        'time': '2:00 PM - 4:00 PM',
        'status': 'Not Approved',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Request Visits',
          style: TextStyle(
            fontSize: 24,
            color:Color(0xFF00008B) ,
            fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(
                  Icons.event,
                  color: request['status'] == 'Approved'
                      ? Colors.green
                      : request['status'] == 'Pending'
                          ? Colors.orange
                          : Colors.red,
                ),
                title: Text(
                  request['venue']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00008B),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    Text('Date: ${request['date']}'),
                    Text('Time: ${request['time']}'),
                    const SizedBox(height: 4.0),
                    Text(
                      'Status: ${request['status']}',
                      style: TextStyle(
                        color: request['status'] == 'Approved'
                            ? Colors.green
                            : request['status'] == 'Pending'
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



