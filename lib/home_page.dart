import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String? _selectedCategory = 'All Pastry';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': '1',
      'name': 'Croissant',
      'category': 'Puff Pastry',
      'price': 10000,
      'image': 'assets/croissant.jpg',
      'description': 'A buttery, flaky croissant with a golden crust.',
    },
    {
      'id': '2',
      'name': 'Pain au Chocolat',
      'category': 'Puff Pastry',
      'price': 12000,
      'image': 'assets/pain-au-chocolat.jpg',
      'description': 'A puff pastry filled with rich chocolate.',
    },
    {
      'id': '3',
      'name': 'Chicken Puff',
      'category': 'Puff Pastry',
      'price': 15000,
      'image': 'assets/pastry-chicken-puff.jpg',
      'description': 'A savory puff pastry stuffed with chicken.',
    },
    {
      'id': '4',
      'name': 'Apple Turnover',
      'category': 'Puff Pastry',
      'price': 14000,
      'image': 'assets/apple-turnover.jpg',
      'description': 'A sweet turnover filled with apple compote.',
    },
    {
      'id': '5',
      'name': 'Apple Danish',
      'category': 'Danish Pastry',
      'price': 13000,
      'image': 'assets/apple-danish.jpg',
      'description': 'A danish pastry with apple filling.',
    },
    {
      'id': '6',
      'name': 'Custard Danish',
      'category': 'Danish Pastry',
      'price': 13500,
      'image': 'assets/custard-danish.jpg',
      'description': 'A danish filled with creamy custard.',
    },
    {
      'id': '7',
      'name': 'Blueberry Danish',
      'category': 'Danish Pastry',
      'price': 14000,
      'image': 'assets/blueberry-danish.jpg',
      'description': 'A danish with fresh blueberry topping.',
    },
    {
      'id': '8',
      'name': 'Strawberry Danish',
      'category': 'Danish Pastry',
      'price': 14500,
      'image': 'assets/strawberry-danish.jpg',
      'description': 'A danish with sweet strawberry filling.',
    },
    {
      'id': '9',
      'name': 'Fruit Tart',
      'category': 'Shortcrust Pastry',
      'price': 18000,
      'image': 'assets/fruit-tart.jpg',
      'description': 'A tart with fresh fruits and custard.',
    },
    {
      'id': '10',
      'name': 'Egg Tart',
      'category': 'Shortcrust Pastry',
      'price': 12000,
      'image': 'assets/egg-tart.jpg',
      'description': 'A classic egg custard tart.',
    },
    {
      'id': '11',
      'name': 'Apple Tart',
      'category': 'Shortcrust Pastry',
      'price': 16000,
      'image': 'assets/apple-tart.jpg',
      'description': 'A tart with caramelized apples.',
    },
    {
      'id': '12',
      'name': 'Chocolate Tart',
      'category': 'Shortcrust Pastry',
      'price': 17000,
      'image': 'assets/chocolate-tart.jpg',
      'description': 'A rich chocolate-filled tart.',
    },
    {
      'id': '13',
      'name': 'Vandbakkelseskrans',
      'category': 'Choux Pastry',
      'price': 20000,
      'image': 'assets/vandbakkelseskrans.webp',
      'description': 'A choux pastry ring with cream.',
    },
    {
      'id': '14',
      'name': 'Chocolate Choux',
      'category': 'Choux Pastry',
      'price': 13000,
      'image': 'assets/chocolate-choux.jpg',
      'description': 'A choux pastry with chocolate cream.',
    },
    {
      'id': '15',
      'name': 'Eclair',
      'category': 'Choux Pastry',
      'price': 15000,
      'image': 'assets/eclair.jpg',
      'description': 'A classic eclair with vanilla cream.',
    },
    {
      'id': '16',
      'name': 'Vanilla Cream Choux',
      'category': 'Choux Pastry',
      'price': 14000,
      'image': 'assets/vanilla-cream-choux.jpg',
      'description': 'A choux pastry with vanilla cream.',
    },
  ];

  Timer? _debounce;
  late List<Map<String, dynamic>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_menuItems);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _filterItems();
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _filterItems();
      });
    });
  }

  void _filterItems() {
    _filteredItems =
        _menuItems.where((item) {
          final matchesCategory =
              _selectedCategory == 'All Pastry' ||
              item['category'] == _selectedCategory;
          final matchesSearch =
              item['name'].toString().toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) ||
              _searchController.text.isEmpty;
          return matchesCategory && matchesSearch;
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            color: Colors.grey[850],
            padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const Text(
                  'Bandar Lampung',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    // <-- removed 'const' here
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search pastry...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => _onSearchChanged(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/home-discount.png',
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                CategoryChip(
                  label: 'All Pastry',
                  isSelected: _selectedCategory == 'All Pastry',
                  onSelected: () => _onCategorySelected('All Pastry'),
                ),
                CategoryChip(
                  label: 'Puff Pastry',
                  isSelected: _selectedCategory == 'Puff Pastry',
                  onSelected: () => _onCategorySelected('Puff Pastry'),
                ),
                CategoryChip(
                  label: 'Danish Pastry',
                  isSelected: _selectedCategory == 'Danish Pastry',
                  onSelected: () => _onCategorySelected('Danish Pastry'),
                ),
                CategoryChip(
                  label: 'Shortcrust Pastry',
                  isSelected: _selectedCategory == 'Shortcrust Pastry',
                  onSelected: () => _onCategorySelected('Shortcrust Pastry'),
                ),
                CategoryChip(
                  label: 'Choux Pastry',
                  isSelected: _selectedCategory == 'Choux Pastry',
                  onSelected: () => _onCategorySelected('Choux Pastry'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return MenuItemCard(
                  id: item['id'] as String,
                  name: item['name'] as String,
                  category: item['category'] as String,
                  price: item['price'] as num,
                  image: item['image'] as String,
                  description: item['description'] as String,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0)
            return;
          else if (index == 1)
            Navigator.pushNamed(context, '/chatbot');
          else if (index == 2)
            Navigator.pushNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class CategoryChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  CategoryChipState createState() => CategoryChipState();
}

class CategoryChipState extends State<CategoryChip> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Text(widget.label, style: const TextStyle(color: Colors.white)),
        selected: widget.isSelected,
        onSelected: (bool selected) => widget.onSelected(),
        selectedColor: Colors.brown[300],
        backgroundColor: Colors.brown[600],
      ),
    );
  }
}

class MenuItemCard extends StatefulWidget {
  final String id;
  final String name;
  final String category;
  final num price;
  final String image;
  final String description;

  const MenuItemCard({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
  });

  @override
  MenuItemCardState createState() => MenuItemCardState();
}

class MenuItemCardState extends State<MenuItemCard> {
  @override
  Widget build(BuildContext context) {
    final nameFontSize = widget.name.length > 12 ? 14.0 : 18.0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/menu-item-detail',
          arguments: {
            'id': widget.id,
            'name': widget.name,
            'category': widget.category,
            'price': widget.price,
            'image': widget.image,
            'description': widget.description,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: const Icon(Icons.error, size: 50, color: Colors.red),
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: nameFontSize,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              widget.category,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rp ${NumberFormat('#,###', 'id_ID').format(widget.price)}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/menu-item-detail',
                      arguments: {
                        'id': widget.id,
                        'name': widget.name,
                        'category': widget.category,
                        'price': widget.price,
                        'image': widget.image,
                        'description': widget.description,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[300],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: const Size(30, 30),
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
