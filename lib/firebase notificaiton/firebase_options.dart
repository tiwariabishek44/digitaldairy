import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are only configured for Android.',
      );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdWAO5bnLR3KZSMw9Zk1oqpNYFLZolKIA',
    appId: '1:720062993627:android:190196eff062585b5e28fe',
    messagingSenderId: '720062993627',
    projectId: 'digital-dairy-bd773',
    storageBucket: 'digital-dairy-bd773.firebasestorage.app',
  );
}
