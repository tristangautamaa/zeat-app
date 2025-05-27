import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'cart_provider.dart';

class MenuItemDetailPage extends StatefulWidget {
  final Map<String, dynamic>? itemData;

  const MenuItemDetailPage({super.key, this.itemData});

  @override
  MenuItemDetailPageState createState() => MenuItemDetailPageState();
}

class MenuItemDetailPageState extends State<MenuItemDetailPage> {
  String selectedSize = 'Medium';
  bool isLiked = false;
  bool isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.itemData == null) {
      return const Scaffold(body: Center(child: Text('Item not found')));
    }

    final item = widget.itemData!;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final String description =
        item['description'] ??
        'A delicious pastry made with the finest ingredients.';
    final String displayDescription =
        isDescriptionExpanded || description.length <= 100
            ? description
            : '${description.substring(0, 100)}... ';
    final double rating = 4.5;
    final bool isDiscounted = false;
    final double discountPrice = item['price'] * 0.9;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 30,
                    color: isLiked ? Colors.red : Colors.black,
                  ),
                  onPressed: () => setState(() => isLiked = !isLiked),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          item['image'],
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              item['category'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        children: [
                          TextSpan(text: displayDescription),
                          if (!isDescriptionExpanded &&
                              description.length > 100)
                            WidgetSpan(
                              child: GestureDetector(
                                onTap:
                                    () => setState(
                                      () => isDescriptionExpanded = true,
                                    ),
                                child: const Text(
                                  ' Read more',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB3672B),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pack size',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizeButton(
                            size: 'Small',
                            selectedSize: selectedSize,
                            onPressed:
                                () => setState(() => selectedSize = 'Small'),
                          ),
                          const SizedBox(width: 10),
                          SizeButton(
                            size: 'Medium',
                            selectedSize: selectedSize,
                            onPressed:
                                () => setState(() => selectedSize = 'Medium'),
                          ),
                          const SizedBox(width: 10),
                          SizeButton(
                            size: 'Large',
                            selectedSize: selectedSize,
                            onPressed:
                                () => setState(() => selectedSize = 'Large'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      isDiscounted
                          ? 'Rp ${NumberFormat('#,###', 'id_ID').format(discountPrice)}'
                          : 'Rp ${NumberFormat('#,###', 'id_ID').format(item['price'])}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB3672B),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    cartProvider.addItem(
                      item['id'],
                      item['name'],
                      isDiscounted ? discountPrice : item['price'],
                      item['image'],
                    );
                    Navigator.pushNamed(context, '/shopping-cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB3672B),
                    side: const BorderSide(color: Color(0xFFB3672B)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SizeButton extends StatefulWidget {
  final String size;
  final String selectedSize;
  final VoidCallback onPressed;

  const SizeButton({
    super.key,
    required this.size,
    required this.selectedSize,
    required this.onPressed,
  });

  @override
  SizeButtonState createState() => SizeButtonState();
}

class SizeButtonState extends State<SizeButton> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedSize == widget.size;
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFB3672B)),
        backgroundColor: isSelected ? const Color(0xFFB3672B) : Colors.grey[50],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        widget.size,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFFB3672B),
          fontSize: 16,
        ),
      ),
    );
  }
}
