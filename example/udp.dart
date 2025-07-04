import 'package:dnslib/dnslib.dart';


void main() {

    // Print example progress
    print('Executing UDP example ...');

    // UDP DNS service
    final DnsServer dnsServer = DnsServer(
        host: '8.8.8.8',
        port: 53, // Optional. Value is by default.
        protocol: DnsProtocol.udp, // Optional, value is by default.
    );

    // Create query
    DNSClient.query(
        domain: 'example.com',
        dnsRecordType: DNSRecordTypes.findByName('A'),
        dnsServer: dnsServer
    )
    .then((records) {
        for (DNSResponseRecord record in records)
            print(record); // By default print in josn format
    })
    .catchError((error) { // Catch any error here
        throw error;
    });
}