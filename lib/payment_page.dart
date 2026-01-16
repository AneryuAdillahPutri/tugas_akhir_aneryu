import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'dashboard_page.dart';

class PaymentPage extends StatefulWidget {
  final int totalPrice;
  const PaymentPage({super.key, required this.totalPrice});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Pilihan metode bayar default
  String _selectedPayment = 'QRIS';
  bool _isLoading = false;

  void _processPayment() async {
    setState(() => _isLoading = true);

    // 1. Simulasi Loading (Pura-pura ngehubungin Bank)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() => _isLoading = false);

      // 2. Kosongkan Keranjang
      Provider.of<CartProvider>(context, listen: false).clearCart();

      // 3. Tampilkan Pesan Sukses
      showDialog(
        context: context,
        barrierDismissible: false, // User gabisa klik luar buat tutup
        builder: (context) => AlertDialog(
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("Pembayaran Berhasil!"),
            ],
          ),
          content: const Text("Terima kasih sudah berbelanja. Paketmu akan segera dikirim!"),
          actions: [
            TextButton(
              onPressed: () {
                // Balik ke Dashboard & Hapus semua history halaman
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                  (route) => false,
                );
              },
              child: const Text("OK, Belanja Lagi"),
            ),
          ],
        ),
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
            const Text(
              "Total Tagihan:",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "Rp ${widget.totalPrice}",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 30),
            const Text("Pilih Metode Pembayaran:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // PILIHAN 1: QRIS
            _buildRadioOption("QRIS (GoPay/OVO/Dana)", "QRIS", Icons.qr_code),
            
            // PILIHAN 2: TRANSFER BANK
            _buildRadioOption("Transfer Bank (BCA)", "Transfer", Icons.account_balance),
            
            // PILIHAN 3: COD
            _buildRadioOption("Bayar di Tempat (COD)", "COD", Icons.local_shipping),

            const Spacer(),

            // TOMBOL BAYAR
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
                          Text("Memproses...", style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : Text("BAYAR SEKARANG (Rp ${widget.totalPrice})", 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget kecil buat bikin tombol pilihan biar rapi
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
        onChanged: (val) {
          setState(() {
            _selectedPayment = val.toString();
          });
        },
      ),
    );
  }
}