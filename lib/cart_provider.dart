import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  // 👇 UPDATE: Sekarang terima parameter 'image' juga
  void addItem(String name, int price, String image) {
    _items.add({
      'name': name,
      'price': price,
      'image': image, // Simpan URL fotonya
    });
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  int get totalPrice {
    int total = 0;
    for (var item in _items) {
      total += (item['price'] as int);
    }
    return total;
  }
}