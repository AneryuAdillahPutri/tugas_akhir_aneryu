import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_provider.dart';
import 'dashboard_page.dart';

class PaymentPage extends StatefulWidget {
  final int totalPrice;
  const PaymentPage({super.key, required this.totalPrice});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = 'QRIS';
  bool _isLoading = false;

  void _processPayment() async {
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    final cart = Provider.of<CartProvider>(context, listen: false);
    
    if (user == null) {
       setState(() => _isLoading = false);
       return;
    }

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'user_email': user.email,
        'user_id': user.uid,
        'total_price': widget.totalPrice,
        'payment_method': _selectedPayment,
        'items': cart.items,
        'order_date': DateTime.now(),
        'status': 'Success'
      });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        cart.clearCart();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 10),
                Text("Transaksi Berhasil!"),
              ],
            ),
            content: const Text("Data pesananmu sudah tersimpan aman di Database Server."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardPage()),
                    (route) => false,
                  );
                },
                child: const Text("OK, Mantap!"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan pesanan: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Total Tagihan:", style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text(
              "Rp ${widget.totalPrice}",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 30),
            const Text("Pilih Metode Pembayaran:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            _buildRadioOption("QRIS (GoPay/OVO)", "QRIS", Icons.qr_code),
            _buildRadioOption("Transfer Bank (BCA)", "Transfer", Icons.account_balance),
            _buildRadioOption("Bayar di Tempat (COD)", "COD", Icons.local_shipping),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
                          SizedBox(width: 10),
                          Text("Menyimpan ke Database...", style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : Text("BAYAR SEKARANG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: _selectedPayment == value ? Colors.blue : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: _selectedPayment == value ? Colors.blue.shade50 : Colors.white,
      ),
      child: RadioListTile(
        title: Text(title, style: TextStyle(fontWeight: _selectedPayment == value ? FontWeight.bold : FontWeight.normal)),
        value: value,
        groupValue: _selectedPayment,
        secondary: Icon(icon, color: Colors.blue),
        activeColor: Colors.blue,
        onChanged: (val) => setState(() => _selectedPayment = val.toString()),
      ),
    );
  }
}