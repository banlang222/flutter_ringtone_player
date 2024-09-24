import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player_platform_interface.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterRingtonePlayerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterRingtonePlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterRingtonePlayerPlatform initialPlatform = FlutterRingtonePlayerPlatform.instance;

  test('$MethodChannelFlutterRingtonePlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterRingtonePlayer>());
  });

  test('getPlatformVersion', () async {
    FlutterRingtonePlayer flutterRingtonePlayerPlugin = FlutterRingtonePlayer();
    MockFlutterRingtonePlayerPlatform fakePlatform = MockFlutterRingtonePlayerPlatform();
    FlutterRingtonePlayerPlatform.instance = fakePlatform;

    expect(await flutterRingtonePlayerPlugin.getPlatformVersion(), '42');
  });
}
