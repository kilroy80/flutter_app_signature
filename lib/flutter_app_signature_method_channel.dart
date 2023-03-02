import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_app_signature_platform_interface.dart';

/// An implementation of [FlutterAppSignaturePlatform] that uses method channels.
class MethodChannelFlutterAppSignature extends FlutterAppSignaturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_app_signature');

  @override
  Future<List<String>> getAppSignature() async {
    if (Platform.isAndroid) {
      var list = await methodChannel.invokeListMethod<String>('appSignature');
      if (list != null) {
        return list;
      } else {
        return List.empty();
      }
    } else {
      return List.empty();
    }
  }
}
