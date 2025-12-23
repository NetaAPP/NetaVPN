import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import '../models/vpn_server.dart';

class VpnGateService {
  static Future<List<VpnServer>> fetchServers() async {
    final res = await http.get(
      Uri.parse('https://www.vpngate.net/api/iphone/')
    );

    final csv = const CsvToListConverter().convert(res.body);
    final headers = csv[1];

    List<VpnServer> list = [];

    for (int i = 2; i < csv.length; i++) {
      final row = csv[i];
      if (row.length < headers.length) continue;

      Map<String, dynamic> map = {};
      for (int j = 0; j < headers.length; j++) {
        map[headers[j]] = row[j];
      }

      list.add(VpnServer.fromCsv(map));
    }

    list.sort((a, b) => a.ping.compareTo(b.ping));
    return list;
  }
}
