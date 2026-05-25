import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não foram configuradas para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAf9BJdglur05jzwax7Eujxk5LiyHGTiTI',
    appId: '1:142274125577:web:f16350accea02fb8bbbdd8',
    messagingSenderId: '142274125577',
    projectId: 'monitor-indicadores-econ-6dce5',
    storageBucket: 'monitor-indicadores-econ-6dce5.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAf9BJdglur05jzwax7Eujxk5LiyHGTiTI',
    appId: '1:142274125577:web:f16350accea02fb8bbbdd8',
    messagingSenderId: '142274125577',
    projectId: 'monitor-indicadores-econ-6dce5',
    storageBucket: 'monitor-indicadores-econ-6dce5.firebasestorage.app',
  );
}