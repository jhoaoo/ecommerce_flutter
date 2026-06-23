import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrapper {
  FirebaseConnectionStatus _status = FirebaseConnectionStatus.notInitialized;
  Object? _lastError;

  FirebaseConnectionStatus get status => _status;
  Object? get lastError => _lastError;
  bool get isConnected => _status == FirebaseConnectionStatus.connected;

  Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      _status = FirebaseConnectionStatus.connected;
      return;
    }

    try {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyCcMN5vi59_RX_LFHWrR5Cy0pb1l-EEc38',
            authDomain: 'ecommerce-7ea77.firebaseapp.com',
            projectId: 'ecommerce-7ea77',
            storageBucket: 'ecommerce-7ea77.firebasestorage.app',
            messagingSenderId: '37769907589',
            appId: '1:37769907589:web:cc0504e720a3f4975388ec',
            measurementId: 'G-C7G36MNP7D',
          ),
        );
      } else {
        await Firebase.initializeApp();
      }

      _status = FirebaseConnectionStatus.connected;
    } catch (error) {
      _lastError = error;
      _status = FirebaseConnectionStatus.demoMode;
    }
  }
}

enum FirebaseConnectionStatus { notInitialized, connected, demoMode }

extension FirebaseConnectionStatusText on FirebaseConnectionStatus {
  String get label {
    switch (this) {
      case FirebaseConnectionStatus.connected:
        return 'Servicio disponible';
      case FirebaseConnectionStatus.demoMode:
        return 'Modo de prueba local';
      case FirebaseConnectionStatus.notInitialized:
        return 'Inicializando tienda';
    }
  }
}
