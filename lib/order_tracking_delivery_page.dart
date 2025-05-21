import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home_page.dart'; // Ensure this file exists or adjust the import

class OrderTrackingDeliveryPage extends StatefulWidget {
  final String orderAddress;
  final double total;
  final List<dynamic> items;
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
  _OrderTrackingDeliveryPageState createState() =>
      _OrderTrackingDeliveryPageState();
}

class _OrderTrackingDeliveryPageState extends State<OrderTrackingDeliveryPage> {
  GoogleMapController? mapController;
  final LatLng _storePosition = const LatLng(
    -6.1745,
    106.8227,
  ); // Store in Jakarta
  final LatLng _deliveryPosition = const LatLng(
    -5.1477,
    105.1985,
  ); // Bandar Lampung (approximate)
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
    _markers.add(
      Marker(
        markerId: const MarkerId('delivery_location'),
        position: _deliveryPosition,
        infoWindow: const InfoWindow(title: 'Delivery Location'),
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
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            _storePosition.latitude < _deliveryPosition.latitude
                ? _storePosition.latitude
                : _deliveryPosition.latitude,
            _storePosition.longitude < _deliveryPosition.longitude
                ? _storePosition.longitude
                : _deliveryPosition.longitude,
          ),
          northeast: LatLng(
            _storePosition.latitude > _deliveryPosition.latitude
                ? _storePosition.latitude
                : _deliveryPosition.latitude,
            _storePosition.longitude > _deliveryPosition.longitude
                ? _storePosition.longitude
                : _deliveryPosition.longitude,
          ),
        ),
        50.0, // Padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simulate estimated delivery time (current time + 45 minutes)
    final now = DateTime.now();
    final estimatedDeliveryTime = now.add(const Duration(minutes: 45));
    final formattedTime = TimeOfDay.fromDateTime(
      estimatedDeliveryTime,
    ).format(context);

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
                        'Estimated Delivery Time',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Driver Information',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Text(
                        'John Doe - +62 812-3456-7890',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
