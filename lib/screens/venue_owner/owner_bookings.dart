import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:venue_app/models/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onMarkAsDone;

  const RequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.onMarkAsDone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: const Color.fromARGB(255, 220, 210, 255),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    request.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00008B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: request.status == 'Approved'
                        ? Colors.green[100]
                        : request.status == 'Rejected'
                            ? Colors.red[100]
                            : request.status == 'Done'
                                ? Colors.blue[100]
                                : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: request.status == 'Approved'
                          ? Colors.green
                          : request.status == 'Rejected'
                              ? Colors.red
                              : request.status == 'Done'
                                  ? Colors.blue
                                  : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Email: ${request.email}', style: const TextStyle(fontSize: 16)),
            Text('Mobile: ${request.mobileNumber}', style: const TextStyle(fontSize: 16)),
            Text('Venue: ${request.venueName}', style: const TextStyle(fontSize: 16)),
            Text('Location: ${request.location}', style: const TextStyle(fontSize: 16)),
            Text('Request Date: ${request.requestDate}', style: const TextStyle(fontSize: 16)),
            Text('Request Time: ${request.requestTime}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible( // Allow buttons to shrink if needed
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible( // Allow buttons to shrink if needed
                  child: ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible( // Allow buttons to shrink if needed
                  child: ElevatedButton(
                    onPressed: onMarkAsDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Mark as Done',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// BookingsPage widget
class OwnerBookingsPage extends StatefulWidget {
  const OwnerBookingsPage({super.key});

  @override
  _OwnerBookingsPageState createState() => _OwnerBookingsPageState();
}

class _OwnerBookingsPageState extends State<OwnerBookingsPage> {
  List<Request> requests = [];
  String _selectedOption = 'Requests'; // Default selected option

  @override
  void initState() {
    super.initState();
    fetchRequests(); // Fetch requests when the widget is initialized
  }

  Future<void> fetchRequests() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/database/fetch_requests.php'));

    if (response.statusCode == 200) {
      // Parse response as a List
      List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        requests = jsonData.map<Request>((item) {
          return Request(
            id: item['id'] ?? '',
            fullName: item['full_name'] ?? '',
            email: item['email'] ?? '',
            mobileNumber: item['mobile_number'] ?? '',
            venueName: item['venue_name'] ?? '',
            location: item['location'] ?? '',
            requestDate: item['request_date'] ?? '',
            requestTime: item['request_time'] ?? '',
            status: item['status'] ?? 'Pending',
          );
        }).toList(); // Map each item to a Request object
      });
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<void> markAsDone(String requestId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/database/mark_as_done.php'),
      body: json.encode({'id': requestId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      fetchRequests();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked as Done.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to mark as done.')));
    }
  }

  Future<void> approveRequest(String requestId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/database/approve_request.php'),
      body: json.encode({'id': requestId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      fetchRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to approve request.')));
    }
  }

  Future<void> rejectRequest(String requestId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/database/reject_request.php'),
      body: json.encode({'id': requestId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      fetchRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to reject request.')));
    }
  }

  Future<void> showApproveDialog(Request request) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Approve Request'),
          content: const Text('Are you sure you want to approve this request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false when canceled
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true when approved
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      approveRequest(request.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request approved.')));
    }
  }

  Future<void> showRejectDialog(Request request) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Request'),
          content: const Text('Are you sure you want to reject this request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false when canceled
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true when rejected
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      rejectRequest(request.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request rejected.')));
    }
  }

  Future<void> showMarkAsDoneDialog(Request request) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mark as Done'),
          content: const Text('Are you sure you want to mark this request as done?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false when canceled
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true when marked as done
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      markAsDone(request.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request marked as done.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookings / Requests',
          style: TextStyle(
            color: Color(0xFF00008B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          DropdownButton<String>(
            value: _selectedOption,
            items: [
              'Bookings',
              'Requests',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue!;
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _selectedOption == 'Bookings' ? _buildBookingsList() : _buildRequestsList(),
    );
  }

  Widget _buildRequestsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return RequestCard(
            request: requests[index],
            onApprove: () {
              showApproveDialog(requests[index]);
            },
            onReject: () {
              showRejectDialog(requests[index]);
            },
            onMarkAsDone: () {
              showMarkAsDoneDialog(requests[index]);
            }
          );
        },
      ),
    );
  }

  // Dummy function for bookings list
  Widget _buildBookingsList() {
    return const Center(child: Text('No bookings available.')); // Replace with actual bookings list
  }
  
}
