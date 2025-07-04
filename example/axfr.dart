import 'package:dnslib/dnslib.dart';

// Source server: https://digi.ninja/projects/zonetransferme.php

void main() {

    // Print example progress
    print('Executing AXFR example ...');

    // TCP DNS service with AXFR enabled
    final DnsServer dnsServer = DnsServer(
        host: 'nsztm1.digi.ninja',
        port: 53, // Optional. Value is by default.
        protocol: DnsProtocol.tcp, // AXFR is only supported by TCP connections.
    );

    // Create query
    DNSClient.query(
        domain: 'zonetransfer.me',
        dnsRecordType: DNSRecordTypes.findByName('AXFR'),
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