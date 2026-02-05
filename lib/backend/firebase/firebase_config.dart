import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyARHZaK8DTe5kYoe5rTpo1SE9oY_L5lZKI",
            authDomain: "ecommerce-7ea77.firebaseapp.com",
            projectId: "ecommerce-7ea77",
            storageBucket: "ecommerce-7ea77.firebasestorage.app",
            messagingSenderId: "37769907589",
            appId: "1:37769907589:web:cc0504e720a3f4975388ec",
            measurementId: "G-C7G36MNP7D"));
  } else {
    await Firebase.initializeApp();
  }
}
