// File generated manually because flutterfire configure timed out.
// Firebase project: vinyl-wa

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'Android Firebase options are not configured yet. '
              'Run flutterfire configure for Android later.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS Firebase options are not configured yet. '
              'Run flutterfire configure for iOS later.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'macOS Firebase options are not configured yet. '
              'Run flutterfire configure for macOS later.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows Firebase options are not configured yet. '
              'Run flutterfire configure for Windows later.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux Firebase options are not configured yet.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDh7h_uV0K8w5T8jDaioJIxxbEapZ15UmY',
    appId: '1:869975499217:web:ccb0a70db91c05747bc0f0',
    messagingSenderId: '869975499217',
    projectId: 'vinyl-wa',
    authDomain: 'vinyl-wa.firebaseapp.com',
    storageBucket: 'vinyl-wa.firebasestorage.app',
  );
}