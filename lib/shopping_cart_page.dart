import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'cart_provider.dart';
import 'order_tracking_delivery_page.dart';
import 'order_tracking_pickup_page.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ShoppingCartPageState createState() => ShoppingCartPageState();
}

class ShoppingCartPageState extends State<ShoppingCartPage> {
  String _deliveryMethod = 'Deliver';
  String _deliveryAddress = 'Jl. Pattimura Kpg. Sutoyo No. 620, Bandar Lampung';
  final String _storeLocation = 'Bakery Delight, Jl. Merdeka No. 123, Jakarta';
  String _paymentMethod = 'Cash';
  bool _discountApplied = false;
  GoogleMapController? mapController;
  final LatLng _storePosition = const LatLng(-6.1745, 106.8227);
  final Set<Marker> _markers = {};
  late TextEditingController _addressController; // For address
  late TextEditingController _voucherController; // For voucher

  @override
  void initState() {
    super.initState();
    _discountApplied = false;
    _markers.add(
      const Marker(
        markerId: MarkerId('store_location'),
        position: LatLng(-6.1745, 106.8227),
        infoWindow: InfoWindow(title: 'Bakery Delight'),
      ),
    );
    _requestLocationPermission();
    _addressController = TextEditingController(text: _deliveryAddress);
    _voucherController =
        TextEditingController(); // Initialize voucher controller
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted && mounted) {
      setState(() {});
    }
  }

  void _editAddress() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: TextField(
            controller: _addressController,
            decoration: const InputDecoration(hintText: 'Enter new address'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _deliveryAddress = _addressController.text;
                });
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
    );
  }

  void _applyDiscount(String code) {
    if (code == 'DISKON50') {
      setState(() {
        _discountApplied = true;
      });
    }
  }

  void _showVoucherDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Voucher Code'),
          content: TextField(
            controller: _voucherController,
            decoration: const InputDecoration(hintText: 'Enter code'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _applyDiscount(_voucherController.text);
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
            TextButton(
              onPressed: () {
                _voucherController.clear(); // Clear input on cancel
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String get _pickUpTime {
    final now = DateTime.now();
    final pickUpTime = now.add(const Duration(minutes: 30));
    return DateFormat('hh:mm a').format(pickUpTime);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _voucherController.dispose();
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final bool isCartEmpty = cart.items.isEmpty;

    final int deliveryFee = isCartEmpty ? 0 : 5000;
    final String orderAddress =
        _deliveryMethod == 'Pick Up' ? _storeLocation : _deliveryAddress;
    final double cartTotal = cart.totalPrice;
    final double discountAmount = _discountApplied && !isCartEmpty ? 4000 : 0;
    final double total = cartTotal + deliveryFee - discountAmount;

    final initialCameraPosition = CameraPosition(
      target: _storePosition,
      zoom: 14.0,
    );

    void onMapCreated(GoogleMapController controller) {
      mapController = controller;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(_storePosition, 14.0),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Order',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Non-scrollable middle section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            () => setState(() => _deliveryMethod = 'Deliver'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _deliveryMethod == 'Deliver'
                                  ? Colors.brown
                                  : Colors.grey[300],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Deliver',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            () => setState(() => _deliveryMethod = 'Pick Up'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _deliveryMethod == 'Pick Up'
                                  ? Colors.brown
                                  : Colors.grey[300],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Pick Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_deliveryMethod == 'Deliver') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              _deliveryAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          TextButton(
                            onPressed: _editAddress,
                            child: const Text(
                              'Edit Address',
                              style: TextStyle(color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Store Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _storeLocation,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GoogleMap(
                        onMapCreated: onMapCreated,
                        initialCameraPosition: initialCameraPosition,
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        markers: _markers,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Pick up by $_pickUpTime',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _showVoucherDialog,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _discountApplied
                              ? '1 Discount is Applied'
                              : 'No discount applied',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
              // Scrollable items section
              Expanded(
                child:
                    isCartEmpty
                        ? const Center(child: Text('Your cart is empty'))
                        : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 200),
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return Card(
                              margin: const EdgeInsets.only(
                                bottom: 4,
                                left: 16,
                                right: 16,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        cart.removeItem(item.id);
                                      },
                                    ),
                                    Image.asset(
                                      item.image,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.error,
                                          size: 40,
                                          color: Colors.red,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            'Rp ${NumberFormat('#,###', 'id_ID').format(item.price)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            cart.decreaseQuantity(item.id);
                                          },
                                        ),
                                        Text('${item.quantity}'),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            cart.increaseQuantity(item.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
          if (!isCartEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey[50],
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Price'),
                              Text(
                                'Rp ${NumberFormat('#,###', 'id_ID').format(cartTotal)}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Delivery Fee'),
                              Text(
                                'Rp ${NumberFormat('#,###', 'id_ID').format(deliveryFee)}',
                              ),
                            ],
                          ),
                          if (_discountApplied && !isCartEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Discount',
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text(
                                  '-Rp ${NumberFormat('#,###', 'id_ID').format(discountAmount)}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp ${NumberFormat('#,###', 'id_ID').format(total)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: _paymentMethod,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                          DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _paymentMethod = newValue;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final cart = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );
                          if (_deliveryMethod == 'Deliver') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => OrderTrackingDeliveryPage(
                                      orderAddress: orderAddress,
                                      total: total,
                                      items: cart.items,
                                      deliveryFee: deliveryFee,
                                      paymentMethod: _paymentMethod,
                                    ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => OrderTrackingPickupPage(
                                      storeLocation: _storeLocation,
                                      pickUpTime: _pickUpTime,
                                      total: total,
                                      items: cart.items,
                                      paymentMethod: _paymentMethod,
                                    ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Center(
                          child: Text(
                            'Order',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
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
