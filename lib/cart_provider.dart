import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
      0,
      (total, item) => total + (item.price * item.quantity),
    );
  }

  void addItem(String id, String name, double price, String image) {
    final existingItemIndex = _items.indexWhere((item) => item.id == id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(CartItem(id: id, name: name, price: price, image: image));
    }
    notifyListeners();
  }

  void increaseQuantity(String id) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity += 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity -= 1;
      if (_items[itemIndex].quantity <= 0) {
        _items.removeAt(itemIndex);
      }
      notifyListeners();
    }
  }
}
