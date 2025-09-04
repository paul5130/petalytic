import 'package:petalytic/main.dart';
import 'firebase_options_stg.dart';

void main() async {
  await runMainApp(firebaseOptions: DefaultFirebaseOptions.currentPlatform);
}
