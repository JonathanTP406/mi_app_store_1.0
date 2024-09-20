// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
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
    apiKey: 'AIzaSyBYzrtJvqNiE6NSX9uoL2DzB_wDZu728FY',
    appId: '1:450615655932:web:d0164c48747dd2e95c4679',
    messagingSenderId: '450615655932',
    projectId: 'mi-app-store-1-1',
    authDomain: 'mi-app-store-1-1.firebaseapp.com',
    storageBucket: 'mi-app-store-1-1.appspot.com',
    measurementId: 'G-K36ZZ3Y33S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLzZZw5Oqoe47vljPd18P5MjcWre_1dpA',
    appId: '1:450615655932:android:1ca70567d5661ba75c4679',
    messagingSenderId: '450615655932',
    projectId: 'mi-app-store-1-1',
    storageBucket: 'mi-app-store-1-1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA3HM-7dvv5XwrKjnZYj2I10d-JEuQDfDk',
    appId: '1:450615655932:ios:b820f93d1790c6fd5c4679',
    messagingSenderId: '450615655932',
    projectId: 'mi-app-store-1-1',
    storageBucket: 'mi-app-store-1-1.appspot.com',
    iosClientId: '450615655932-umq2m9q7uc0v58p5hc2h2jv59pvh01kr.apps.googleusercontent.com',
    iosBundleId: 'com.example.miAppStore11',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA3HM-7dvv5XwrKjnZYj2I10d-JEuQDfDk',
    appId: '1:450615655932:ios:b820f93d1790c6fd5c4679',
    messagingSenderId: '450615655932',
    projectId: 'mi-app-store-1-1',
    storageBucket: 'mi-app-store-1-1.appspot.com',
    iosClientId: '450615655932-umq2m9q7uc0v58p5hc2h2jv59pvh01kr.apps.googleusercontent.com',
    iosBundleId: 'com.example.miAppStore11',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBYzrtJvqNiE6NSX9uoL2DzB_wDZu728FY',
    appId: '1:450615655932:web:0c7ad533109e24f75c4679',
    messagingSenderId: '450615655932',
    projectId: 'mi-app-store-1-1',
    authDomain: 'mi-app-store-1-1.firebaseapp.com',
    storageBucket: 'mi-app-store-1-1.appspot.com',
    measurementId: 'G-SHYQ6KFSGT',
  );
}