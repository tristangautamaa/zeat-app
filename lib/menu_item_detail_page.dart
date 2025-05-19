import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'cart_provider.dart';

class MenuItemDetailPage extends StatefulWidget {
  final String menuItemId;

  const MenuItemDetailPage({super.key, required this.menuItemId});

  @override
  MenuItemDetailPageState createState() => MenuItemDetailPageState();
}

class MenuItemDetailPageState extends State<MenuItemDetailPage> {
  String selectedSize = 'Medium';
  bool isLiked = false;
  bool isDescriptionExpanded = false;

  final Map<String, Map<String, dynamic>> _menuItems = {
    '1': {
      'name': 'Croissant',
      'category': 'Puff Pastry',
      'price': 10000,
      'image': 'assets/croissant.jpg',
      'description':
          'A flaky, buttery croissant with a golden crust, perfect for breakfast or a snack. Made with premium ingredients to ensure a melt-in-your-mouth experience.',
      'rating': 4.5,
    },
    '2': {
      'name': 'Pain au Chocolat',
      'category': 'Puff Pastry',
      'price': 12000,
      'image': 'assets/pain-au-chocolat.jpg',
      'description':
          'A delightful puff pastry filled with rich dark chocolate, offering a perfect balance of crispy layers and gooey sweetness.',
      'rating': 4.8,
    },
    '3': {
      'name': 'Chicken Puff',
      'category': 'Puff Pastry',
      'price': 15000,
      'image': 'assets/pastry-chicken-puff.jpg',
      'description':
          'A savory puff pastry filled with tender chicken and aromatic spices, ideal for a quick and satisfying meal.',
      'rating': 4.2,
    },
    '4': {
      'name': 'Apple Turnover',
      'category': 'Puff Pastry',
      'price': 14000,
      'image': 'assets/apple-turnover.jpg',
      'description':
          'A classic puff pastry turnover stuffed with sweet, cinnamon-spiced apples, offering a delightful mix of textures.',
      'rating': 4.6,
    },
    '5': {
      'name': 'Apple Danish',
      'category': 'Danish Pastry',
      'price': 13000,
      'image': 'assets/apple-danish.jpg',
      'description':
          'A tender Danish pastry topped with caramelized apples, finished with a light glaze for a sweet touch.',
      'rating': 4.3,
    },
    '6': {
      'name': 'Custard Danish',
      'category': 'Danish Pastry',
      'price': 13500,
      'image': 'assets/custard-danish.jpg',
      'description':
          'A rich custard-filled Danish pastry with a flaky base, perfect for those who love creamy desserts.',
      'rating': 4.7,
    },
    '7': {
      'name': 'Blueberry Danish',
      'category': 'Danish Pastry',
      'price': 14000,
      'image': 'assets/blueberry-danish.jpg',
      'description':
          'A Danish pastry bursting with fresh blueberries, topped with a drizzle of icing for extra sweetness.',
      'rating': 4.4,
    },
    '8': {
      'name': 'Strawberry Danish',
      'category': 'Danish Pastry',
      'price': 14500,
      'image': 'assets/strawberry-danish.jpg',
      'description':
          'A flaky Danish pastry filled with juicy strawberries, offering a refreshing and sweet flavor.',
      'rating': 4.9,
    },
    '9': {
      'name': 'Fruit Tart',
      'category': 'Shortcrust Pastry',
      'price': 18000,
      'image': 'assets/fruit-tart.jpg',
      'description':
          'A vibrant shortcrust tart filled with creamy custard and topped with an assortment of fresh fruits.',
      'rating': 4.8,
    },
    '10': {
      'name': 'Egg Tart',
      'category': 'Shortcrust Pastry',
      'price': 12000,
      'image': 'assets/egg-tart.jpg',
      'description':
          'A classic egg tart with a silky custard filling in a crisp shortcrust shell, perfect for any time of day.',
      'rating': 4.5,
    },
    '11': {
      'name': 'Apple Tart',
      'category': 'Shortcrust Pastry',
      'price': 16000,
      'image': 'assets/apple-tart.jpg',
      'description':
          'A rustic shortcrust tart with thinly sliced apples, baked to a golden perfection with a hint of cinnamon.',
      'rating': 4.6,
    },
    '12': {
      'name': 'Chocolate Tart',
      'category': 'Shortcrust Pastry',
      'price': 17000,
      'image': 'assets/chocolate-tart.jpg',
      'description':
          'A decadent shortcrust tart filled with rich chocolate ganache, perfect for chocolate lovers.',
      'rating': 4.9,
    },
    '13': {
      'name': 'Vandbakkelseskrans',
      'category': 'Choux Pastry',
      'price': 20000,
      'image': 'assets/vandbakkelseskrans.webp',
      'description':
          'A traditional Danish choux pastry ring, filled with cream and topped with icing, a true festive treat.',
      'rating': 4.7,
    },
    '14': {
      'name': 'Chocolate Choux',
      'category': 'Choux Pastry',
      'price': 13000,
      'image': 'assets/chocolate-choux.jpg',
      'description':
          'A light choux pastry puff filled with chocolate cream, offering a delightful chocolatey experience.',
      'rating': 4.4,
    },
    '15': {
      'name': 'Eclair',
      'category': 'Choux Pastry',
      'price': 15000,
      'image': 'assets/eclair.jpg',
      'description':
          'A classic eclair with a choux pastry shell, filled with vanilla cream and topped with chocolate glaze.',
      'rating': 4.8,
    },
    '16': {
      'name': 'Vanilla Cream Choux',
      'category': 'Choux Pastry',
      'price': 14000,
      'image': 'assets/vanilla-cream-choux.jpg',
      'description':
          'A delicate choux pastry filled with smooth vanilla cream, dusted with powdered sugar for a simple delight.',
      'rating': 4.5,
    },
  };

  Map<String, dynamic>? get _currentItem => _menuItems[widget.menuItemId];

  @override
  Widget build(BuildContext context) {
    if (_currentItem == null) {
      return Scaffold(body: Center(child: Text('Item not found')));
    }

    String displayDescription =
        isDescriptionExpanded
            ? _currentItem!['description']
            : _currentItem!['description'].length > 100
            ? _currentItem!['description'].substring(0, 100) + '... '
            : _currentItem!['description'];

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
                  icon: Icon(Icons.arrow_back, size: 30, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
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
                  onPressed: () {
                    if (!mounted) return;
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
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
                          _currentItem!['image'],
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error,
                              size: 50,
                              color: Colors.red,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentItem!['name'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _currentItem!['category'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 24),
                            SizedBox(width: 4),
                            Text(
                              _currentItem!['rating'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        children: [
                          TextSpan(text: displayDescription),
                          if (!isDescriptionExpanded &&
                              _currentItem!['description'].length > 100)
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  if (!mounted) return;
                                  setState(() {
                                    isDescriptionExpanded = true;
                                  });
                                },
                                child: Text(
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
                    SizedBox(height: 16),
                    Text(
                      'Pack size',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSizeButton('Small'),
                          SizedBox(width: 10),
                          _buildSizeButton('Medium'),
                          SizedBox(width: 10),
                          _buildSizeButton('Large'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                      'Rp ${NumberFormat('#,###', 'id_ID').format(_currentItem!['price'])}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB3672B),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    final cart = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    );
                    cart.addItem(
                      widget.menuItemId,
                      _currentItem!['name'],
                      _currentItem!['price'].toDouble(),
                      _currentItem!['image'],
                    );
                    Navigator.pushNamed(context, '/shopping-cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB3672B),
                    side: BorderSide(color: Color(0xFFB3672B)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
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

  Widget _buildSizeButton(String size) {
    bool isSelected = selectedSize == size;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedSize = size;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFFB3672B)),
        backgroundColor: isSelected ? Color(0xFFB3672B) : Colors.grey[50],
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        size,
        style: TextStyle(
          color: isSelected ? Colors.white : Color(0xFFB3672B),
          fontSize: 16,
        ),
      ),
    );
  }
}
