// File generated by FlutterFire CLI.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjhnt075XnIEjuZJVE_zkxrRYmi9Ns8Sw',
    appId: '1:586456667520:android:7e9503a8f1fc4222479d65',
    messagingSenderId: '586456667520',
    projectId: 'learning-app-4df40',
    storageBucket: 'learning-app-4df40.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqZSBlnVH4rr1BMmkURhJpBMUfdWxsENk',
    appId: '1:586456667520:ios:699dc801e449427e479d65',
    messagingSenderId: '586456667520',
    projectId: 'learning-app-4df40',
    storageBucket: 'learning-app-4df40.appspot.com',
    iosClientId:
        '586456667520-sb7jchq8q1scb6ca818aoml5v2f5924v.apps.googleusercontent.com',
    iosBundleId: 'com.example.readingApp',
  );
}
