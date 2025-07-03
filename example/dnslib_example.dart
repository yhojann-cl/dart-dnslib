import 'package:dnslib/dnslib.dart';


Future<void> main() async {
    await exampleUDP();
    await exampleTCP();
    await exampleDoH();
    await exampleZonetransfer();
}

Future<void> exampleUDP() async {

    // Print example progress
    print('Executing UDP example ...');

    // UDP DNS service
    final DnsServer dnsServer = DnsServer(
        host: '8.8.8.8',
        port: 53, // Optional. Value is by default.
        protocol: DnsProtocol.udp, // Optional, value is by default.
    );

    // Create query
    await DNSClient
        .query(
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

Future<void> exampleTCP() async {

    // Print example progress
    print('Executing TCP example ...');

    // TCP DNS service
    final DnsServer dnsServer = DnsServer(
        host: '8.8.8.8',
        port: 53, // Optional. Value is by default.
        protocol: DnsProtocol.tcp,
    );

    // Create query
    await DNSClient
        .query(
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

Future<void> exampleDoH() async {

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
    await DNSClient
        .query(
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

Future<void> exampleZonetransfer() async {

    // Reference: https://digi.ninja/projects/zonetransferme.php

    // Print example progress
    print('Executing AXFR example ...');

    // TCP DNS service with AXFR enabled
    final DnsServer dnsServer = DnsServer(
        host: 'nsztm1.digi.ninja',
        port: 53, // Optional. Value is by default.
        protocol: DnsProtocol.tcp, // AXFR is only supported by TCP connections.
    );

    // Create query
    await DNSClient
        .query(
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