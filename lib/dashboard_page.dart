import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'cart_page.dart';
import 'home_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Laptop Gaming',
      'price': '15.000.000',
      'image': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=150'
    },
    {
      'name': 'Mouse Wireless',
      'price': '150.000',
      'image': 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=150'
    },
    {
      'name': 'Keyboard RGB',
      'price': '500.000',
      'image': 'https://images.unsplash.com/photo-1587829741301-dc798b91a603?w=150'
    },
    {
      'name': 'Monitor 24 Inch',
      'price': '2.000.000',
      'image': 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=150'
    },
    {
      'name': 'Headset Bass',
      'price': '350.000',
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=150'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
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
    );
  }
}