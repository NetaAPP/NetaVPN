import 'package:flutter/material.dart';
import 'pages/test_vpn_page.dart';

void main() {
  runApp(const NetaVPNApp());
}

class NetaVPNApp extends StatelessWidget {
  const NetaVPNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetaVPN Test',
      home: TestVpnPage(),
    );
  }
}
