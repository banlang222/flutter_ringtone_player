import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player_method_channel.dart';

void main() {
  MethodChannelFlutterRingtonePlayer platform = MethodChannelFlutterRingtonePlayer();
  const MethodChannel channel = MethodChannel('flutter_ringtone_player');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
