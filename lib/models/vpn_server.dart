class VpnServer {
  final String host;
  final String country;
  final int ping;

  VpnServer({
    required this.host,
    required this.country,
    required this.ping,
  });

  factory VpnServer.fromCsv(Map<String, dynamic> row) {
    return VpnServer(
      host: row['HostName'],
      country: row['CountryLong'],
      ping: int.tryParse(row['Ping'].toString()) ?? 9999,
    );
  }
}
