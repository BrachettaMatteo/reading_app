/// This file content information for connection app to firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:reading_app/screen/login/secure.dart';

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
          "This project not support macOs, it's only run Android and Ios ",
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          "This project not support Windows, it's only run Android and Ios ",
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          "This project not support Linux, it's only run Android and Ios ",
        );
      default:
        throw UnsupportedError(
          ' This project not supported for this platform.',
        );
    }
  }

  static FirebaseOptions android = FirebaseOptions(
    apiKey: apiKeyAndroid,
    appId: appIdAndroid,
    messagingSenderId: messagingSenderIdAndroid,
    projectId: projectIdAndroid,
    storageBucket: storageBucketAndroid,
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: apiKeyIos,
    appId: appIdIos,
    messagingSenderId: messagingSenderIdIos,
    projectId: projectIdIos,
    storageBucket: storageBucketIos,
    iosClientId: iosClientIdIos,
    iosBundleId: iosBundleIdIos,
  );
}

/// firebase collection Users
CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('Users');

/// firebase collection Books
CollectionReference booksCollection =
    FirebaseFirestore.instance.collection('Books');
