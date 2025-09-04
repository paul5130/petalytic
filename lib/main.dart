import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'flavors.dart';

Future<void> runMainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  runApp(const App());
}
