import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class KXResponseRecord extends DNSResponseRecord {
  
    final int preference;
    final String exchanger;

    KXResponseRecord({
        required String name,
        required int ttl,
        required this.preference,
        required this.exchanger,
    }) : super(name: name, ttl: ttl);

    static KXResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length < 3 || (offset + 2) >= bytes.length) {
            throw FormatException('Invalid KX record: too short');
        }

        final int preference = (bytes[offset] << 8) | bytes[offset + 1];
        final (finalOffset, exchanger) = DNSHelper.parseDomainName(bytes, offset + 2);

        return KXResponseRecord(
            name: name,
            ttl: ttl,
            preference: preference,
            exchanger: exchanger);
    }

    @override
    String get type => 'KX';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'preference': preference,
        'exchanger': exchanger,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
