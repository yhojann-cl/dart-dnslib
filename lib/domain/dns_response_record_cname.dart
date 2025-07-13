import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class CNAMEResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final String canonicalName;

    CNAMEResponseRecord({
        required this.name,
        required this.ttl,
        required this.canonicalName,
    }) : super(name: name, ttl: ttl);

    static CNAMEResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if ((offset + length) > bytes.length) {
            throw FormatException('Invalid CNAME record: out of bounds');
        }

        final (_, cname) = DNSHelper.parseDomainName(bytes, offset);

        return CNAMEResponseRecord(
            name: name,
            ttl: ttl,
            canonicalName: cname);
    }

    @override
    String get type => 'CNAME';

    @override
    String get representation => canonicalName;

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'canonicalName': canonicalName,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}