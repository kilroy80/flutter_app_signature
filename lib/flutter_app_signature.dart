import 'dart:io';

import 'package:flutter/foundation.dart';

import 'flutter_app_signature_platform_interface.dart';

class FlutterAppSignature {
  Future<List<String>> getAppSignature() {
    return FlutterAppSignaturePlatform.instance.getAppSignature();
  }

  Future<bool> checkAppSignature(List<String> allowList) async {
    if (!kIsWeb && Platform.isAndroid) {
      var appSignatureList = await FlutterAppSignature().getAppSignature();

      var result = allowList.where((element) => appSignatureList.contains(element));
      if (result.isEmpty) {
        // disallow
        return false;
      } else {
        // allow
        return true;
      }
    } else {
      // other platform always true
      return true;
    }
  }
}
