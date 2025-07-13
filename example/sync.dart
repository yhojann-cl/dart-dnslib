import 'package:dnslib/dnslib.dart';

Future<void> main() async {

    // Print example progress
    print('Executing sync example ...');

    try{

        // Create query
        List<DNSResponseRecord> records = await DNSClient.query(
            domain: 'example.com',
            dnsRecordType: DNSRecordTypes.findByName('A'),
            dnsServer: DNSServer(
                host: '8.8.8.8',
                port: 53, // Optional. Value is by default.
                protocol: DNSProtocol.tcp,
            )
        );

        // Process each record
        for (DNSResponseRecord record in records) {
            print(record); // By default print in josn format
        }
    
    } catch(e) {
        // Catch errors here ...
    }
}