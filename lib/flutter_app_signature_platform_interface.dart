import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_app_signature_method_channel.dart';

abstract class FlutterAppSignaturePlatform extends PlatformInterface {
  /// Constructs a FlutterAppSignaturePlatform.
  FlutterAppSignaturePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAppSignaturePlatform _instance = MethodChannelFlutterAppSignature();

  /// The default instance of [FlutterAppSignaturePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAppSignature].
  static FlutterAppSignaturePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAppSignaturePlatform] when
  /// they register themselves.
  static set instance(FlutterAppSignaturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<String>> getAppSignature() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
