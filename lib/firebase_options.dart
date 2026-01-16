import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web belum dikonfigurasi.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS belum dikonfigurasi.');
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS belum dikonfigurasi.');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows belum dikonfigurasi.');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux belum dikonfigurasi.');
      default:
        throw UnsupportedError('Platform tidak didukung.');
    }
  }

  // 👇 INI DATA ASLI DARI JSON KAMU (BUKAN DUMMY)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAM8lReK6zsAO78qZxjZ-Bw6BgOq8NUPH8',
    appId: '1:951649145448:android:d886f08002dedd892ba1dd',
    messagingSenderId: '951649145448',
    projectId: 'tugasakhiraneryu',
    storageBucket: 'tugasakhiraneryu.firebasestorage.app',
  );
}