import 'package:dnslib/dnslib.dart';


void main() {
    
    // Print example progress
    print('Executing DoH example ...');

    // DoH DNS service
    final DnsServer dnsServer = DnsServer(
        host: 'dns.google',
        port: 443,
        protocol: DnsProtocol.doh,
        path: '/dns-query', // Optional. Value is by default
        /* headers: const { // Optional. Value is by default
            'Accept': 'application/dns-message',
            'Content-Type': 'application/dns-message',
            'Connection': 'close',
        }, */
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