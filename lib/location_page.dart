import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  LocationPageState createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  final List<Map<String, String>> _locations = [
    {'address': 'Jl. Merdeka No. 123, Jakarta', 'city': 'Jakarta'},
    {'address': 'Jl. Sudirman No. 456, Bandung', 'city': 'Bandung'},
  ];

  void _addLocation() {
    final addressController = TextEditingController();
    final cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(hintText: 'Enter address'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(hintText: 'Enter city'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (addressController.text.isNotEmpty &&
                    cityController.text.isNotEmpty) {
                  setState(() {
                    _locations.add({
                      'address': addressController.text,
                      'city': cityController.text,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((_) {
      addressController.dispose();
      cityController.dispose();
    });
  }

  void _editLocation(int index) {
    final addressController = TextEditingController(
      text: _locations[index]['address'],
    );
    final cityController = TextEditingController(
      text: _locations[index]['city'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(hintText: 'Enter address'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(hintText: 'Enter city'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (addressController.text.isNotEmpty &&
                    cityController.text.isNotEmpty) {
                  setState(() {
                    _locations[index] = {
                      'address': addressController.text,
                      'city': cityController.text,
                    };
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((_) {
      addressController.dispose();
      cityController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed:
              () => Navigator.pushReplacementNamed(context, '/admin-dashboard'),
        ),
        title: const Text('Location', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _locations.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[800]?.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _locations[index]['address']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _locations[index]['city']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _editLocation(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLocation,
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
