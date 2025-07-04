import 'package:dnslib/dnslib.dart';


Future<void> main() async {

    // Print example progress
    print('Executing servers example ...');

    // Process each dns server
    for(DnsServer server in DnsServers.servers) {

        try {
            // Create query
            print('Sending query to ${server.host} ...');
            final List<DNSResponseRecord> records = await DNSClient.query(
                domain: 'example.com',
                dnsRecordType: DNSRecordTypes.findByName('A'),
                dnsServer: server,
            );

            for (DNSResponseRecord record in records)
                print(record); // By default print in josn format
        
        } catch(e) {
            print('DNS server error from ${server.host}: ${e}');
        }
    }
}