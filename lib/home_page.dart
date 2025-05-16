import 'package:flutter/material.dart';
import 'chatbot_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _selectedCategory;

  static const List<Widget> _pages = <Widget>[
    HomeContent(),
    ChatbotPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Categories', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Column(
        children: [
          // Mini slider for categories
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.brown[800],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryChip(
                    label: 'All',
                    isSelected: _selectedCategory == 'All',
                    onSelected: () {
                      setState(() {
                        _selectedCategory = 'All';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Fast Food',
                    isSelected: _selectedCategory == 'Fast Food',
                    onSelected: () {
                      setState(() {
                        _selectedCategory = 'Fast Food';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Cakes',
                    isSelected: _selectedCategory == 'Cakes',
                    onSelected: () {
                      setState(() {
                        _selectedCategory = 'Cakes';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Pastries',
                    isSelected: _selectedCategory == 'Pastries',
                    onSelected: () {
                      setState(() {
                        _selectedCategory = 'Pastries';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Drinks',
                    isSelected: _selectedCategory == 'Drinks',
                    onSelected: () {
                      setState(() {
                        _selectedCategory = 'Drinks';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page Content',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
