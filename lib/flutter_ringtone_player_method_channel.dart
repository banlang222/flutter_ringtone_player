import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ringtone_player_platform_interface.dart';

/// An implementation of [FlutterRingtonePlayerPlatform] that uses method channels.
class MethodChannelFlutterRingtonePlayer extends FlutterRingtonePlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ringtone_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
