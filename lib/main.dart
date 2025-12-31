import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'flavors.dart';

Future<void> runMainApp({required FirebaseOptions firebaseOptions}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: firebaseOptions);
  final container = ProviderContainer();

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );
  // runApp(const App());
  runApp(UncontrolledProviderScope(container: container, child: App()));
}
