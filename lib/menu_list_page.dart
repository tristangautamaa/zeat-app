import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  MenuListPageState createState() => MenuListPageState();
}

class MenuListPageState extends State<MenuListPage> {
  // Fake data for menu items (to be replaced with Firebase later)
  List<Map<String, dynamic>> _menuItems = [
    {
      'name': 'Chocolate Croissant',
      'description': 'A flaky croissant with rich chocolate filling.',
      'price': 25000.0,
      'image': 'assets/chocolate_croissant.png',
    },
    {
      'name': 'Blueberry Muffin',
      'description': 'A soft muffin packed with fresh blueberries.',
      'price': 20000.0,
      'image': 'assets/blueberry_muffin.png',
    },
    {
      'name': 'Sourdough Bread',
      'description': 'A crusty sourdough loaf with a tangy flavor.',
      'price': 30000.0,
      'image': 'assets/sourdough_bread.png',
    },
  ];

  void _addMenuItem() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Menu Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Enter name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(hintText: 'Enter price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  setState(() {
                    _menuItems.add({
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'price': double.tryParse(priceController.text) ?? 0.0,
                      'image':
                          'assets/placeholder_food.png', // Placeholder image
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      descriptionController.dispose();
      priceController.dispose();
    });
  }

  void _editMenuItem(int index) {
    final nameController = TextEditingController(
      text: _menuItems[index]['name'],
    );
    final descriptionController = TextEditingController(
      text: _menuItems[index]['description'],
    );
    final priceController = TextEditingController(
      text: _menuItems[index]['price'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Menu Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Enter name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(hintText: 'Enter price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  setState(() {
                    _menuItems[index] = {
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'price': double.tryParse(priceController.text) ?? 0.0,
                      'image':
                          _menuItems[index]['image'], // Retain the same image
                    };
                  });
                }
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
    ).then((_) {
      nameController.dispose();
      descriptionController.dispose();
      priceController.dispose();
    });
  }

  void _deleteMenuItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Menu Item'),
          content: Text(
            'Are you sure you want to delete ${_menuItems[index]['name']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _menuItems.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed:
              () => Navigator.pushReplacementNamed(context, '/admin-dashboard'),
        ),
        title: const Text('Menu List', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[800]?.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Placeholder image (replace with actual asset if available)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    _menuItems[index]['image']!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[600],
                        child: const Icon(Icons.fastfood, color: Colors.white),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _menuItems[index]['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _menuItems[index]['description']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(_menuItems[index]['price'])}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _editMenuItem(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMenuItem(index),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMenuItem,
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
