import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'cart_page.dart';
import 'home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedCategory = 'Semua';

  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Laptop Gaming',
      'price': 15000000,
      'image': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=150',
      'category': 'Laptop'
    },
    {
      'name': 'Macbook Air',
      'price': 18000000,
      'image': 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=150',
      'category': 'Laptop'
    },
    {
      'name': 'Mouse Wireless',
      'price': 150000,
      'image': 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=150',
      'category': 'Aksesoris'
    },
    {
      'name': 'Keyboard RGB',
      'price': 500000,
      'image': 'https://images.unsplash.com/photo-1587829741301-dc798b91a603?w=150',
      'category': 'Aksesoris'
    },
    {
      'name': 'Monitor 24 Inch',
      'price': 2000000,
      'image': 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=150',
      'category': 'Hardware'
    },
    {
      'name': 'Headset Bass',
      'price': 350000,
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=150',
      'category': 'Aksesoris'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayedProducts = _selectedCategory == 'Semua'
        ? allProducts
        : allProducts.where((item) => item['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Toko Elektronik"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Berhasil Logout")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                _buildCategoryButton('Semua'),
                _buildCategoryButton('Laptop'),
                _buildCategoryButton('Aksesoris'),
                _buildCategoryButton('Hardware'),
              ],
            ),
          ),

          Expanded(
            child: displayedProducts.isEmpty
                ? const Center(child: Text("Barang tidak ditemukan"))
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayedProducts[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  product['image'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.broken_image, size: 50));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    product['category'],
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Rp ${product['price']}",
                                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                      onPressed: () {
                                        Provider.of<CartProvider>(context, listen: false).addItem(
                                          product['name'],
                                          product['price'],
                                          product['image'],
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("${product['name']} masuk keranjang!"),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      child: const Text("Beli", style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String categoryName) {
    final isSelected = _selectedCategory == categoryName;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(categoryName),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = categoryName;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.blue.shade100,
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        checkmarkColor: Colors.blue,
      ),
    );
  }
}