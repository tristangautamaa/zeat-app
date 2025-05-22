import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_page.dart';
import 'thank_you_page.dart';

class OrderTrackingDeliveryPage extends StatefulWidget {
  const OrderTrackingDeliveryPage({
    super.key,
    required this.orderAddress,
    required this.total,
    required this.items,
    required this.deliveryFee,
    required this.paymentMethod,
  });

  final String orderAddress;
  final double total;
  final List<dynamic> items;
  final int deliveryFee;
  final String paymentMethod;

  @override
  State<OrderTrackingDeliveryPage> createState() =>
      _OrderTrackingDeliveryPageState();
}

class _OrderTrackingDeliveryPageState extends State<OrderTrackingDeliveryPage> {
  GoogleMapController? mapController;
  final LatLng _storePosition = const LatLng(-6.1745, 106.8227);
  final LatLng _deliveryPosition = const LatLng(-5.1477, 105.1985);
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
    _markers.add(
      const Marker(
        markerId: MarkerId('delivery_location'),
        position: LatLng(-5.1477, 105.1985),
        infoWindow: InfoWindow(title: 'Delivery Location'),
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
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
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
            50.0,
          ),
        );
      }
    });
  }

  Future<void> _makingPhoneCall() async {
    final status = await Permission.phone.request();
    if (status.isGranted) {
      final launchUri = Uri(scheme: 'tel', path: '+62817209700');
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch dialer')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone permission denied')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final truncatedAddress =
        widget.orderAddress.length > 20
            ? '${widget.orderAddress.substring(0, 20)}...'
            : widget.orderAddress;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
      body: SafeArea(
        child: Column(
          children: [
            // "Order Received" button at the top
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const ThankYouPage(title: 'Order Received'),
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
                    'Order Received',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            // Map taking up the remaining space
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(-6.1745, 106.8227),
                      zoom: 14.0,
                    ),
                    mapType: MapType.normal,
                    markers: _markers,
                  ),
                  // Semi-transparent overlay for content at the bottom
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
                          // 1. "10 minutes left" black bold, top and center
                          const Center(
                            child: Text(
                              '10 minutes left',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 2. "Delivery to" and truncated address
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery to',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                truncatedAddress,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 20,
                          ),
                          const SizedBox(height: 12),
                          // 3. Motorcycle icon and text, aligned to the right
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.motorcycle,
                                  size: 30,
                                  color: Colors.orange[700],
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'On the way to restaurant',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'We will deliver your goods to you in the shortest possible time.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // 4. Driver image, name, motorcycle name, and call button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/driver.jpg',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.person, size: 60),
                                ),
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Yohanes Vincentius',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Ninja H2R',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green[100],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                  onPressed: _makingPhoneCall,
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
            ),
          ],
        ),
      ),
    );
  }
}
