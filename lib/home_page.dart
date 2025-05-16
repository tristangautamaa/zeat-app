import 'package:flutter/material.dart';
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
    },
    {
      'id': '2',
      'name': 'Pain au Chocolat',
      'category': 'Puff Pastry',
      'price': 12000,
      'image': 'assets/pain-au-chocolat.jpg',
    },
  ];

  Timer? _debounce;
  late List<Map<String, dynamic>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = _menuItems; // Initialize with all items
    _filterItems(); // Initial filter
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

  void _onSearchChanged(String value) {
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
          bool matchesCategory =
              _selectedCategory == 'All Pastry' ||
              item['category'] == _selectedCategory;
          bool matchesSearch =
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
            height:
                MediaQuery.of(context).size.height * 0.20, // Reduced from 0.25
            color: Colors.grey[850],
            padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  'Bandar Lampung',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search pastry...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ],
            ),
          ),
          // Reverted to simpler layout with SizedBox spacing
          SizedBox(height: 10), // Add spacing
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/home-discount.png',
                height: 150, // Kept smaller size
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filteredItems.length, // Use filtered list
              itemBuilder: (context, index) {
                var item = _filteredItems[index];
                return MenuItemCard(
                  id: item['id'],
                  name: item['name'],
                  category: item['category'],
                  price: item['price'],
                  image: item['image'],
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
          // Placeholder for navigation (to be implemented later)
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

class CategoryChip extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(color: Colors.white)),
        selected: isSelected,
        onSelected: (bool selected) {
          onSelected();
        },
        selectedColor: Colors.brown[300],
        backgroundColor: Colors.brown[600],
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String id;
  final String name;
  final String category;
  final num price;
  final String image;

  const MenuItemCard({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/menu-item-detail', arguments: id);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 100, height: 100, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              category,
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rp $price',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[300],
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size(30, 30),
                  ),
                  child: Text(
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
