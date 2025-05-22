import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home_page.dart';
import 'thank_you_page.dart';

class OrderTrackingPickupPage extends StatefulWidget {
  const OrderTrackingPickupPage({
    super.key,
    required this.storeLocation,
    required this.pickUpTime,
    required this.total,
    required this.items,
    required this.paymentMethod,
  });

  final String storeLocation;
  final String pickUpTime;
  final double total;
  final List<dynamic> items;
  final String paymentMethod;

  @override
  State<OrderTrackingPickupPage> createState() =>
      _OrderTrackingPickupPageState();
}

class _OrderTrackingPickupPageState extends State<OrderTrackingPickupPage> {
  GoogleMapController? mapController;
  final LatLng _storePosition = const LatLng(-6.1745, 106.8227);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(
      const Marker(
        markerId: MarkerId('store_location'),
        position: LatLng(-6.1745, 106.8227),
        infoWindow: InfoWindow(title: 'Bakery Delight'),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_storePosition, 14.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map taking up the full screen
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-6.1745, 106.8227),
              zoom: 14.0,
            ),
            mapType: MapType.normal,
            markers: _markers,
          ),
          // Home button at top left
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.home, size: 30, color: Colors.black),
              onPressed: () {
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                }
              },
            ),
          ),
          // Semi-transparent overlay for content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white.withAlpha(229),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Pick up time
                  Center(
                    child: Text(
                      widget.pickUpTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Pick up time',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 2. Store Address title and location
                  const Center(
                    child: Text(
                      'Store Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      widget.storeLocation,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 3. Order picked up button at the bottom
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ThankYouPage(
                                    title: 'Order Picked Up',
                                  ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Order Picked Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
