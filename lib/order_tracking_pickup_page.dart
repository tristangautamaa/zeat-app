import 'package:flutter/material.dart';
import 'cart_provider.dart'; // Ensure CartItem is imported

class OrderTrackingPickupPage extends StatelessWidget {
  final String storeLocation;
  final String pickUpTime;
  final double total;
  final List<CartItem> items; // Corrected from Cartltem to CartItem
  final String paymentMethod;

  const OrderTrackingPickupPage({
    super.key,
    required this.storeLocation,
    required this.pickUpTime,
    required this.total,
    required this.items,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Tracking')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Order placed! Pickup details will appear here.'),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(child: Text('Map of $storeLocation')),
            ),
            SizedBox(height: 20),
            Text('Pickup Time: $pickUpTime'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for pickup confirmation
              },
              child: Text('Confirm Pickup'),
            ),
          ],
        ),
      ),
    );
  }
}
