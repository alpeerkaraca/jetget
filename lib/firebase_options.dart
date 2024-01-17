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
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0E-NIeTb58sUnv6vQDXxJ92kQYNz5an8',
    appId: '1:54981235964:web:3b514f57f341a6cd96f379',
    messagingSenderId: '54981235964',
    projectId: 'jetget-dc76f',
    authDomain: 'jetget-dc76f.firebaseapp.com',
    storageBucket: 'jetget-dc76f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDe9RK9MjcWiJ7BSfKIOy5sQ-fzh8lu3XE',
    appId: '1:54981235964:android:bdd6cf1c6b6a232896f379',
    messagingSenderId: '54981235964',
    projectId: 'jetget-dc76f',
    storageBucket: 'jetget-dc76f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxZ-KH2vA8NQzdxUfv5Cohccw8ds59JYY',
    appId: '1:54981235964:ios:e21418aee3e7671c96f379',
    messagingSenderId: '54981235964',
    projectId: 'jetget-dc76f',
    storageBucket: 'jetget-dc76f.appspot.com',
    iosBundleId: 'com.example.jetget',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxZ-KH2vA8NQzdxUfv5Cohccw8ds59JYY',
    appId: '1:54981235964:ios:552b4791872f637a96f379',
    messagingSenderId: '54981235964',
    projectId: 'jetget-dc76f',
    storageBucket: 'jetget-dc76f.appspot.com',
    iosBundleId: 'com.example.jetget.RunnerTests',
  );
}
