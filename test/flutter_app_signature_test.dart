import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_signature/flutter_app_signature.dart';
import 'package:flutter_app_signature/flutter_app_signature_platform_interface.dart';
import 'package:flutter_app_signature/flutter_app_signature_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAppSignaturePlatform
    with MockPlatformInterfaceMixin
    implements FlutterAppSignaturePlatform {

  @override
  Future<List<String>> getAppSignature() => Future.value(['42']);
}

void main() {
  final FlutterAppSignaturePlatform initialPlatform = FlutterAppSignaturePlatform.instance;

  test('$MethodChannelFlutterAppSignature is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAppSignature>());
  });

  test('getAppSignature', () async {
    FlutterAppSignature flutterAppSignaturePlugin = FlutterAppSignature();
    MockFlutterAppSignaturePlatform fakePlatform = MockFlutterAppSignaturePlatform();
    FlutterAppSignaturePlatform.instance = fakePlatform;

    expect(await flutterAppSignaturePlugin.getAppSignature(), ['42']);
  });
}
