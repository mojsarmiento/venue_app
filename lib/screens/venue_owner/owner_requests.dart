import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/request_bloc.dart'; // Adjust this import as needed
import 'package:venue_app/bloc/request_event.dart';
import 'package:venue_app/bloc/request_state.dart';

class OwnerRequests extends StatelessWidget {
  const OwnerRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Requests',
          style: TextStyle(
            color: Color(0xFF00008B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            if (state is RequestLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RequestLoaded) {
              return ListView.builder(
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return RequestCard(
                    name: request.fullName,
                    venueName: request.venueName,
                    date: request.requestDate,
                    time: request.requestTime,
                    onApprove: () {
                      // Dispatch approve request event
                      context.read<RequestBloc>().add(ApproveRequestEvent(request.id));
                    },
                    onReject: () {
                      // Dispatch reject request event
                      context.read<RequestBloc>().add(RejectRequestEvent(request.id));
                    },
                  );
                },
              );
            } else if (state is RequestError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No requests found.'));
          },
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final String name;
  final String venueName;
  final String date;
  final String time;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const RequestCard({
    super.key,
    required this.name,
    required this.venueName,
    required this.date,
    required this.time,
    required this.onApprove,
    required this.onReject,
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
                  onPressed: onApprove,
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
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  child: const Text(
                    'Reject',
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

