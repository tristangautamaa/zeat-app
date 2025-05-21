import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home_page.dart'; // Ensure this file exists or adjust the import

class OrderTrackingPickupPage extends StatefulWidget {
  final String storeLocation;
  final String pickUpTime;
  final double total;
  final List<dynamic> items;
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
  _OrderTrackingPickupPageState createState() =>
      _OrderTrackingPickupPageState();
}

class _OrderTrackingPickupPageState extends State<OrderTrackingPickupPage> {
  GoogleMapController? mapController;
  final LatLng _storePosition = const LatLng(
    -6.1745,
    106.8227,
  ); // Store in Jakarta
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('store_location'),
        position: _storePosition,
        infoWindow: const InfoWindow(title: 'Bakery Delight'),
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
          // Map taking up 70% of the screen
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom:
                MediaQuery.of(context).size.height *
                0.3, // 70% of screen height
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _storePosition,
                zoom: 14.0,
              ),
              mapType: MapType.normal,
              markers: _markers,
            ),
          ),
          // Home button at top left
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.home, size: 30, color: Colors.black),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false, // Clear the navigation stack
                );
              },
            ),
          ),
          // White tab with rounded corners at the bottom 30%
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height:
                MediaQuery.of(context).size.height *
                0.3, // 30% of screen height
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Tracking',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pick Up Time',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        widget.pickUpTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Store Address: ${widget.storeLocation}',
                    style: const TextStyle(fontSize: 16),
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
