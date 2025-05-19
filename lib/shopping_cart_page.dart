import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'cart_provider.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  String _deliveryMethod = 'Deliver';
  String _deliveryAddress = 'Jl. Pattimura Kpg. Sutoyo No. 620, Bandar Lampung';
  final String _storeLocation = 'Bakery Delight, Jl. Merdeka No. 123, Jakarta';
  String _paymentMethod = 'Cash';
  bool _discountApplied = false;
  final NumberFormat _numberFormat = NumberFormat('#,###', 'id_ID');

  @override
  void initState() {
    super.initState();
    _discountApplied = false; // Reset discount on page reopen
  }

  void _editAddress() {
    showDialog(
      context: context,
      builder: (context) {
        String newAddress = _deliveryAddress;
        return AlertDialog(
          title: const Text('Edit Address'),
          content: TextField(
            onChanged: (value) => newAddress = value,
            controller: TextEditingController(text: _deliveryAddress),
            decoration: const InputDecoration(hintText: 'Enter new address'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _deliveryAddress = newAddress;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
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
        String voucherCode = '';
        return AlertDialog(
          title: const Text('Enter Voucher Code'),
          content: TextField(
            onChanged: (value) => voucherCode = value,
            decoration: const InputDecoration(hintText: 'Enter code'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _applyDiscount(voucherCode);
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  // Simulate pick-up time (current time + 30 minutes)
  String get _pickUpTime {
    final now = DateTime.now(); // 10:23 AM WIB, May 19, 2025
    final pickUpTime = now.add(const Duration(minutes: 30));
    return DateFormat('hh:mm a').format(pickUpTime); // 10:53 AM
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final bool isCartEmpty = cart.items.isEmpty;

    // Determine delivery fee and address based on delivery method and cart state
    final int deliveryFee =
        isCartEmpty
            ? 0
            : (_deliveryMethod == 'Pick Up'
                ? 0
                : (_discountApplied ? 1000 : 5000));
    final String orderAddress =
        _deliveryMethod == 'Pick Up' ? _storeLocation : _deliveryAddress;
    final double cartTotal = cart.totalPrice;
    final double discountAmount = _discountApplied && !isCartEmpty ? 5000 : 0;
    final double total = cartTotal + deliveryFee - discountAmount;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Order',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
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
                        Row(
                          children: [
                            TextButton(
                              onPressed: _editAddress,
                              child: const Text(
                                'Edit Address',
                                style: TextStyle(color: Colors.brown),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Add Note',
                                style: TextStyle(color: Colors.brown),
                              ),
                            ),
                          ],
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
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Map interaction: Zoom/Pan at $_storeLocation',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/jakarta_map.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              'Jakarta Map\n(Failed to load image)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Pick up by $_pickUpTime',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            if (isCartEmpty) ...[
              const SizedBox(
                height: 200, // Placeholder height to avoid layout jump
                child: Center(child: Text('Your cart is empty')),
              ),
            ] else ...[
              SizedBox(
                height: 300, // Fixed height to ensure scrollable area
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
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
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      size: 50,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        'Rp ${_numberFormat.format(item.price)}',
                                        style: const TextStyle(
                                          fontSize: 14,
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
                    );
                  },
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: _showVoucherDialog,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _discountApplied
                            ? '1 Discount is Applies'
                            : 'No discount applied',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price'),
                      Text('Rp ${_numberFormat.format(cartTotal)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_deliveryMethod == 'Deliver') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Fee',
                          style: TextStyle(color: Colors.black),
                        ),
                        Row(
                          children: [
                            if (!isCartEmpty && _discountApplied) ...[
                              Text(
                                'Rp ${_numberFormat.format(5000)}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Rp ${_numberFormat.format(1000)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ] else ...[
                              Text(
                                'Rp ${_numberFormat.format(deliveryFee)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
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
                        'Rp ${_numberFormat.format(total)}',
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
              padding: const EdgeInsets.all(16.0),
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
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  try {
                    final cart = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    );
                    // Log order details for debugging (replace with logging framework in production)
                    debugPrint(
                      'Order placed (simulated): userId: placeholder_user_id, items: ${cart.items.map((item) => {"id": item.id, "name": item.name, "price": item.price, "quantity": item.quantity}).toList()}, totalAmount: $total, deliveryFee: $deliveryFee, deliveryAddress: $orderAddress, discountCode: ${_discountApplied ? 'DISKON50' : ''}, discountAmount: $discountAmount, paymentMethod: $_paymentMethod',
                    );
                    Navigator.pushNamed(context, '/order-tracking');
                  } catch (e, stackTrace) {
                    debugPrint('Error placing order: $e\n$stackTrace');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error placing order: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 15),
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
    );
  }
}
