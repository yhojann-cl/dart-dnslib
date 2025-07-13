import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class AFSDBResponseRecord extends DNSResponseRecord {

    final String name;
    final int ttl;
    final int subtype;
    final String hostname;

    AFSDBResponseRecord({
        required this.name,
        required this.ttl,
        required this.subtype,
        required this.hostname,
    }) : super(name: name, ttl: ttl);

    static AFSDBResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        // Length validation
        if((length < 3) || ((offset + length) > bytes.length)) {
            throw FormatException('Invalid AFSDB record: expected at least 3 bytes, got ${bytes.length}.');
        }

        late String hostname;        
        final int subtype = (bytes[offset + 0] << 8) | bytes[offset + 1]; // Uint8
        (_, hostname) = DNSHelper.parseDomainName(bytes, offset + 2);

        return AFSDBResponseRecord(
            name: name,
            ttl: ttl,
            subtype: subtype,
            hostname: hostname);
    }

    @override
    String get type => 'AFSDB';

    @override
    String get representation => '$subtype $hostname';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'subtype': subtype,
        'hostname': hostname,
    };

    @override
    String toString() => jsonEncode(toJson());
}
