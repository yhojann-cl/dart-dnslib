import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class NSResponseRecord extends DNSResponseRecord {
  
    final String nameserver;

    NSResponseRecord({
        required super.name,
        required super.ttl,
        required this.nameserver,
    });

    static NSResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if ((offset + length) > bytes.length) {
            throw FormatException('Invalid NS record: exceeds byte length.');
        }

        final (_, String nameserver) = DNSHelper.parseDomainName(bytes, offset);

        return NSResponseRecord(
            name: name,
            ttl: ttl,
            nameserver: nameserver);
    }

    @override
    String get type => 'NS';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'nameserver': nameserver,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
