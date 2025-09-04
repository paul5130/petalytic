import 'package:petalytic/main.dart';

import 'firebase_options_dev.dart';

void main() async {
  await runMainApp(firebaseOptions: DefaultFirebaseOptions.currentPlatform);
}
