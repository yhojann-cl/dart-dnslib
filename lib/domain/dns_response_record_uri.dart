import 'dart:convert' show jsonEncode, utf8;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


class URIResponseRecord extends DNSResponseRecord {

    final int priority;
    final int weight;
    final String target;

    URIResponseRecord({
        required super.name,
        required super.ttl,
        required this.priority,
        required this.weight,
        required this.target,
    });

    static URIResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if (length < 4 || offset + length > bytes.length)  {
            throw FormatException('Invalid URI record length');
        }

        final int priority = (bytes[offset] << 8) | bytes[offset + 1];
        final int weight = (bytes[offset + 2] << 8) | bytes[offset + 3];
        final String target = utf8.decode(bytes.sublist(offset + 4, offset + length));

        return URIResponseRecord(
            name: name,
            ttl: ttl,
            priority: priority,
            weight: weight,
            target: target);
    }

    @override
    String get type => 'URI';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'priority': priority,
        'weight': weight,
        'target': target,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}