import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


/**
 *
 */
class MXResponseRecord extends DNSResponseRecord {

    final String name;
    final int ttl;
    final int preference;
    final String exchange;

    MXResponseRecord({
        required this.name,
        required this.ttl,
        required this.preference,
        required this.exchange,
    }) : super(name: name, ttl: ttl);

    static MXResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if (length < 3 || offset + length > bytes.length)
            throw FormatException('Invalid MX record: insufficient length.');
        
        // Leer los dos bytes de preferencia (16 bits)
        final int preference = (bytes[offset] << 8) | bytes[offset + 1];

        // Leer el nombre de host
        final (_, exchange) = DNSHelper.parseDomainName(bytes, offset + 2);

        return MXResponseRecord(
            name: name,
            ttl: ttl,
            preference: preference,
            exchange: exchange);
    }

    @override
    String get type => 'MX';

    @override
    String toString() => jsonEncode({
        'type': type,
        'name': name,
        'ttl': ttl,
        'preference': preference,
        'exchange': exchange,
    });
}
