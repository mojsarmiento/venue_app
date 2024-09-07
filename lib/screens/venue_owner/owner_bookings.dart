import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String _selectedOption = 'Bookings';

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

  Widget _buildBookingsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          BookingCard(
            name: 'John Doe',
            venueName: 'Venue ABC',
            location: 'Location ABC',
            date: '2024-08-22',
            time: '15:00',
            hours: '0',
            totalPrice: '₱0',
            downPayment: '₱0',
          ),
          SizedBox(height: 16),
          BookingCard(
            name: 'Jane Smith',
            venueName: 'Venue XYZ',
            location: 'Location XYZ',
            date: '2024-08-25',
            time: '18:00',
            hours: '0',
            totalPrice: '₱0',
            downPayment: '₱0',
          ),
          // Add more booking cards as needed
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          RequestCard(
            name: 'Alice Johnson',
            venueName: 'Venue A',
            location: 'Location A',
            date: '2024-08-22',
            time: '10:00 AM',
          ),
          SizedBox(height: 16),
          RequestCard(
            name: 'Bob Brown',
            venueName: 'Venue B',
            location: 'Location A',
            date: '2024-08-25',
            time: '2:00 PM',
          ),
          // Add more request cards as needed
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String name;
  final String venueName;
  final String location;
  final String date;
  final String time;
  final String hours;
  final String totalPrice;
  final String downPayment;

  const BookingCard({
    super.key,
    required this.name,
    required this.venueName,
    required this.location,
    required this.date,
    required this.time,
    required this.hours,
    required this.totalPrice,
    required this.downPayment
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reserver: $name',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Venue: $venueName',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: $time',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Hours: $hours',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Price: $totalPrice',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Downpayment: $downPayment',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement approve booking functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement decline booking functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: Colors.white),
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

class RequestCard extends StatelessWidget {
  final String name;
  final String venueName;
  final String location;
  final String date;
  final String time;

  const RequestCard({
    super.key,
    required this.name,
    required this.venueName,
    required this.location,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Requester: $name',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00008B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Venue: $venueName',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: $time',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement approve request functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement decline request functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: Colors.white),
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



