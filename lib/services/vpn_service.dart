import 'package:flutter/services.dart';

class VpnService {
  static const _channel = MethodChannel('netavpn/ipsec');

  static Future<void> connect(String host) async {
    await _channel.invokeMethod('connect', {
      'server': host,
      'username': 'vpn',
      'password': 'vpn',
      'psk': 'vpn',
    });
  }

  static Future<void> disconnect() async {
    await _channel.invokeMethod('disconnect');
  }
}
