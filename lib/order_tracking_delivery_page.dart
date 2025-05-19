import 'package:flutter/material.dart';
import 'cart_provider.dart'; // Ensure CartItem is imported

class OrderTrackingDeliveryPage extends StatelessWidget {
  final String orderAddress;
  final double total;
  final List<CartItem> items; // Corrected from Cartltem to CartItem
  final int deliveryFee;
  final String paymentMethod;

  const OrderTrackingDeliveryPage({
    super.key,
    required this.orderAddress,
    required this.total,
    required this.items,
    required this.deliveryFee,
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
            Text('Order placed! Tracking details will appear here.'),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(child: Text('Map of tracking to $orderAddress')),
            ),
            SizedBox(height: 20),
            Text('Driver: John Doe (ETA: 30 mins)'),
          ],
        ),
      ),
    );
  }
}
