import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'firebase_storage_helper.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  MenuListPageState createState() => MenuListPageState();
}

class MenuListPageState extends State<MenuListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // Add these to manage controllers if you want to avoid memory leaks
  final List<TextEditingController> _controllers = [];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _addMenuItem() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final discountPriceController = TextEditingController();
    _controllers.addAll([
      nameController,
      descriptionController,
      priceController,
      discountPriceController,
    ]);
    bool isDiscounted = false;
    String? categoryId;
    File? imageFile;

    final categories = await _firestore.collection('Categories').get();
    final categoryItems =
        categories.docs.map((doc) => doc.data()['name'] as String).toList();

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Menu Item'),
              content: SingleChildScrollView(
                child: Column(
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
                      decoration: const InputDecoration(
                        hintText: 'Enter price',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      hint: const Text('Select Category'),
                      items:
                          categoryItems.map((category) {
                            return DropdownMenuItem<String>(
                              value:
                                  categories.docs
                                      .firstWhere(
                                        (doc) => doc.data()['name'] == category,
                                      )
                                      .id,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          categoryId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Is Discounted?'),
                        Checkbox(
                          value: isDiscounted,
                          onChanged: (value) {
                            setDialogState(() {
                              isDiscounted = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    if (isDiscounted)
                      TextField(
                        controller: discountPriceController,
                        decoration: const InputDecoration(
                          hintText: 'Enter discount price',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setDialogState(() {
                            imageFile = File(pickedFile.path);
                          });
                        }
                      },
                      child: Text(
                        imageFile == null ? 'Pick Image' : 'Image Selected',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        categoryId != null &&
                        imageFile != null) {
                      final imageUrl = await FirebaseStorageHelper.uploadImageFile(
                        imageFile!,
                        'menu_items/${DateTime.now().millisecondsSinceEpoch}.jpg',
                      );
                      await _firestore.collection('MenuItems').add({
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'price': double.tryParse(priceController.text) ?? 0.0,
                        'imageUrl': imageUrl,
                        'categoryId': categoryId,
                        'isDiscounted': isDiscounted,
                        'discountPrice':
                            isDiscounted
                                ? (double.tryParse(
                                      discountPriceController.text,
                                    ) ??
                                    0.0)
                                : 0.0,
                      });
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editMenuItem(
    int index,
    Map<String, dynamic> item,
    List<Map<String, dynamic>> items,
  ) async {
    final nameController = TextEditingController(text: item['name']);
    final descriptionController = TextEditingController(
      text: item['description'],
    );
    final priceController = TextEditingController(
      text: item['price'].toString(),
    );
    final discountPriceController = TextEditingController(
      text: item['discountPrice']?.toString() ?? '',
    );
    _controllers.addAll([
      nameController,
      descriptionController,
      priceController,
      discountPriceController,
    ]);
    bool isDiscounted = item['isDiscounted'] ?? false;
    String? categoryId = item['categoryId'];
    File? imageFile;
    String imageUrl = item['imageUrl'];

    final categories = await _firestore.collection('Categories').get();
    final categoryItems =
        categories.docs.map((doc) => doc.data()['name'] as String).toList();

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Menu Item'),
              content: SingleChildScrollView(
                child: Column(
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
                      decoration: const InputDecoration(
                        hintText: 'Enter price',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: categoryId,
                      hint: const Text('Select Category'),
                      items:
                          categoryItems.map((category) {
                            return DropdownMenuItem<String>(
                              value:
                                  categories.docs
                                      .firstWhere(
                                        (doc) => doc.data()['name'] == category,
                                      )
                                      .id,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          categoryId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Is Discounted?'),
                        Checkbox(
                          value: isDiscounted,
                          onChanged: (value) {
                            setDialogState(() {
                              isDiscounted = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    if (isDiscounted)
                      TextField(
                        controller: discountPriceController,
                        decoration: const InputDecoration(
                          hintText: 'Enter discount price',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setDialogState(() {
                            imageFile = File(pickedFile.path);
                          });
                        }
                      },
                      child: Text(
                        imageFile == null
                            ? 'Pick New Image'
                            : 'New Image Selected',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        categoryId != null) {
                      if (imageFile != null) {
                        imageUrl = await FirebaseStorageHelper.uploadImageFile(
                          imageFile!,
                          'menu_items/${DateTime.now().millisecondsSinceEpoch}.jpg',
                        );
                      }
                      await _firestore
                          .collection('MenuItems')
                          .doc(item['id'])
                          .update({
                            'name': nameController.text,
                            'description': descriptionController.text,
                            'price':
                                double.tryParse(priceController.text) ?? 0.0,
                            'imageUrl': imageUrl,
                            'categoryId': categoryId,
                            'isDiscounted': isDiscounted,
                            'discountPrice':
                                isDiscounted
                                    ? (double.tryParse(
                                          discountPriceController.text,
                                        ) ??
                                        0.0)
                                    : 0.0,
                          });
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      descriptionController.dispose();
      priceController.dispose();
      discountPriceController.dispose();
    });
  }

  void _deleteMenuItem(String id) async {
    await _firestore.collection('MenuItems').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
            }
          },
        ),
        title: const Text('Menu List', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('MenuItems').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final items =
              snapshot.data!.docs.map((doc) {
                return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
              }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800]?.withAlpha(170),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['imageUrl'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[600],
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.white,
                            ),
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
                            item['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['description'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['isDiscounted'] == true
                                ? 'Rp ${NumberFormat('#,###', 'id_ID').format(item['discountPrice'])} (Disc.)'
                                : 'Rp ${NumberFormat('#,###', 'id_ID').format(item['price'])}',
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
                          onPressed: () => _editMenuItem(index, item, items),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (mounted) {
                              // Added curly braces
                              _deleteMenuItem(item['id']);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
