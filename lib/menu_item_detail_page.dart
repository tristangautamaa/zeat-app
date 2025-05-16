import 'package:flutter/material.dart';

class MenuItemDetailPage extends StatelessWidget {
  final String menuItemId;

  const MenuItemDetailPage({super.key, required this.menuItemId});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> item =
        {
          '1': {'name': 'Croissant', 'description': 'A buttery, flaky pastry.'},
          '2': {
            'name': 'Pain au Chocolat',
            'description': 'A chocolate-filled puff pastry.',
          },
        }[menuItemId] ??
        {'name': 'Unknown', 'description': 'No description available'};

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item['name'],
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${item['description']}',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              child: Text('Back', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
