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
        "This project not support web, it only runs with Android and Ios ",
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          "This project not support macOs,  it only runs with Android and Ios ",
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          "This project not support Windows, it only runs with Android and Ios ",
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          "This project not support Linux, it only runs with Android and Ios ",
        );
      default:
        throw UnsupportedError(
          ' This project not supported for this platform. It only runs with Android and Ios ',
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

/// firestone cloud position of default photo
String defaultPhoto =
    'https://firebasestorage.googleapis.com/v0/b/learning-app-4df40.appspot.com/o/Unknown.png?alt=media&token=c6eafdbe-2833-4bed-9204-7a41e3a64f55';
