import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5XFr_JciNpuGr8x69KIOdU0HpgmU92Q8',
    appId: '1:599422895989:android:5937c1cb660abe008bf53c',
    messagingSenderId: '599422895989',
    projectId: 'campus-gear-share',
    storageBucket: 'campus-gear-share.firebasestorage.app',
  );
}