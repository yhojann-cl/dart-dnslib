import 'package:dnslib/dnslib.dart';


void main() {

    // Print example progress
    print('Executing TCP example ...');

    // TCP DNS service
    final DNSServer dnsServer = DNSServer(
        host: '8.8.8.8',
        port: 53, // Optional. Value is by default.
        protocol: DNSProtocol.tcp,
    );

    // Create query
    DNSClient.query(
        domain: 'example.com',
        dnsRecordType: DNSRecordTypes.findByName('A'),
        dnsServer: dnsServer
    )
    .then((records) {
        for (DNSResponseRecord record in records) {
            print(record); // By default print in josn format
        }
    })
    .catchError((error) { // Catch any error here
        throw error;
    });
}