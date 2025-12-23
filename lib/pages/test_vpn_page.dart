import 'package:flutter/material.dart';
import '../services/vpngate_service.dart';
import '../services/vpn_service.dart';
import '../models/vpn_server.dart';

class TestVpnPage extends StatefulWidget {
  @override
  State<TestVpnPage> createState() => _TestVpnPageState();
}

class _TestVpnPageState extends State<TestVpnPage> {
  late Future<List<VpnServer>> servers;

  @override
  void initState() {
    super.initState();
    servers = VpnGateService.fetchServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NetaVPN Test')),
      body: FutureBuilder<List<VpnServer>>(
        future: servers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snapshot.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final s = list[i];
              return ListTile(
                title: Text(s.country),
                subtitle: Text('${s.host} | ping ${s.ping}'),
                onTap: () async {
                  await VpnService.connect(s.host);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.close),
        onPressed: () {
          VpnService.disconnect();
        },
      ),
    );
  }
}
