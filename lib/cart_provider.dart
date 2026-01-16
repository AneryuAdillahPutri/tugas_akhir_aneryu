import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  // List untuk menyimpan barang belanjaan
  // Isinya: {'name': 'Laptop', 'price': 5000000, 'image': 'https://...'}
  final List<Map<String, dynamic>> _items = [];

  // Getter biar bisa dibaca halaman lain
  List<Map<String, dynamic>> get items => _items;

  // Fungsi Tambah Barang (Sekarang pakai Gambar)
  void addItem(String name, int price, String image) {
    _items.add({
      'name': name,
      'price': price,
      'image': image,
    });
    notifyListeners(); // Kabari semua halaman kalau data berubah
  }

  // Fungsi Hapus Satu Barang (Tong Sampah)
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // Fungsi Kosongkan Keranjang (Dipakai setelah Pembayaran Sukses)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Hitung Total Harga Otomatis
  int get totalPrice {
    int total = 0;
    for (var item in _items) {
      total += (item['price'] as int);
    }
    return total;
  }
}