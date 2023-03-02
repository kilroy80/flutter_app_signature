
import 'flutter_app_signature_platform_interface.dart';

class FlutterAppSignature {
  Future<List<String>> getAppSignature() {
    return FlutterAppSignaturePlatform.instance.getAppSignature();
  }
}
