import 'package:petalytic/firebase_options_prod.dart';
import 'package:petalytic/main.dart';

void main() async {
  await runMainApp(firebaseOptions: DefaultFirebaseOptions.currentPlatform);
}
