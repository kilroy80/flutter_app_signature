import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_signature/flutter_app_signature_method_channel.dart';

void main() {
  MethodChannelFlutterAppSignature platform = MethodChannelFlutterAppSignature();
  const MethodChannel channel = MethodChannel('flutter_app_signature');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getAppSignature(), '42');
  });
}
