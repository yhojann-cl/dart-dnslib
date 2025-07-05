import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


/**
 *
 */
class SRVResponseRecord extends DNSResponseRecord {
  
    final int priority;
    final int weight;
    final int port;
    final String target;

    SRVResponseRecord({
        required super.name,
        required super.ttl,
        required this.priority,
        required this.weight,
        required this.port,
        required this.target,
    });

    static SRVResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if ((offset + length) > bytes.length || length < 6)
            throw FormatException('Invalid SRV record: not enough data.');

        final int priority = (bytes[offset] << 8) | bytes[offset + 1];
        final int weight = (bytes[offset + 2] << 8) | bytes[offset + 3];
        final int port = (bytes[offset + 4] << 8) | bytes[offset + 5];

        final (offsetAfterTarget, target) = DNSHelper.parseDomainName(bytes, offset + 6);

        return SRVResponseRecord(
            name: name,
            ttl: ttl,
            priority: priority,
            weight: weight,
            port: port,
            target: target);
    }

    @override
    String get type => 'SRV';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'priority': priority,
        'weight': weight,
        'port': port,
        'target': target,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
