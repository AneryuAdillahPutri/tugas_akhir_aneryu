import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Wajib
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // KITA PAKSA APLIKASI BACA KUNCI INI (BYPASS FILE JSON YANG RUSAK)
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAM8lReK6zsAO78qZxjZ-Bw6BgOq8NUPH8', 
      appId: '1:951649145448:android:d886f08002dedd892ba1dd', 
      messagingSenderId: '951649145448', 
      projectId: 'tugasakhiraneryu',
      storageBucket: 'tugasakhiraneryu.firebasestorage.app',
    ),
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toko Aneryu',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}