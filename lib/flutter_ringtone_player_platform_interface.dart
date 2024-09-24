import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ringtone_player_method_channel.dart';

abstract class FlutterRingtonePlayerPlatform extends PlatformInterface {
  /// Constructs a FlutterRingtonePlayerPlatform.
  FlutterRingtonePlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterRingtonePlayerPlatform _instance = MethodChannelFlutterRingtonePlayer();

  /// The default instance of [FlutterRingtonePlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterRingtonePlayer].
  static FlutterRingtonePlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterRingtonePlayerPlatform] when
  /// they register themselves.
  static set instance(FlutterRingtonePlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
