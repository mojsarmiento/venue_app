import 'package:flutter/material.dart';
import 'package:venue_app/screens/user/request_details.dart';

class RequestsPage extends StatefulWidget {
  final Map<String, String>? newRequest;

  const RequestsPage({super.key, this.newRequest});

  @override
  // ignore: library_private_types_in_public_api
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final List<Map<String, String>> _requests = [];

  @override
  void initState() {
    super.initState();

    // Add new request if available
    if (widget.newRequest != null) {
      _requests.add(widget.newRequest!);
    }
  }

  // Confirmation dialog for deletion
  Future<bool> _confirmDelete() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Deletion"),
              content: const Text("Are you sure you want to delete this request?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text("Delete"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Requests',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF00008B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _requests.isEmpty
            ? const Center(
                child: Text(
                  'No Requests Yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  final request = _requests[index];

                  final status = request['status'] ?? 'Unknown Status';

                  final canDelete = status != 'Pending';

                  return Dismissible(
                    key: Key(request['venue']!),
                    direction: canDelete
                        ? DismissDirection.endToStart
                        : DismissDirection.none, // Disable swipe for pending requests
                    confirmDismiss: (direction) async {
                      if (canDelete) {
                        return await _confirmDelete();
                      }
                      return false; // Do not delete pending requests
                    },
                    onDismissed: (direction) {
                      final deletedRequest = request;
                      setState(() {
                        _requests.removeAt(index);
                      });

                      // Show SnackBar with "Undo" option
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${deletedRequest['venue']} request deleted"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              setState(() {
                                _requests.insert(index, deletedRequest);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      elevation: 6.0,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestVisitDetailsScreen(
                                requestVisitDetails: request, // Pass full request details
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: status == 'Approved'
                                        ? Colors.green.withOpacity(0.2)
                                        : status == 'Pending'
                                            ? Colors.orange.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                    child: Icon(
                                      Icons.event,
                                      size: 30,
                                      color: status == 'Approved'
                                          ? Colors.green
                                          : status == 'Pending'
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          request['venue']!,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00008B),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Location: ${request['location']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Date: ${request['date']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Time: ${request['time']}',
                                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: status == 'Approved'
                                        ? Colors.green.withOpacity(0.2)
                                        : status == 'Pending'
                                            ? Colors.orange.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: status == 'Approved'
                                          ? Colors.green
                                          : status == 'Pending'
                                              ? Colors.orange
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

















