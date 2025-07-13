import 'dart:convert' show jsonEncode, utf8;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class SVCBResponseRecord extends DNSResponseRecord {

    final int priority;
    final String target;
    final Map<String, String> params;

    SVCBResponseRecord({
        required super.name,
        required super.ttl,
        required this.priority,
        required this.target,
        required this.params,
    });

    static SVCBResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if (length < 3 || (offset + length) > bytes.length) {
            throw FormatException('Invalid SVCB record: too short or out of range');
        }

        final int priority = (bytes[offset] << 8) | bytes[offset + 1];
        final (int newOffset, String target) = DNSHelper.parseDomainName(bytes, offset + 2);
        final Map<int, Uint8List> encoded = { };

        int pOffset = newOffset;
        while (pOffset < offset + length) {
            if (pOffset + 4 > bytes.length) {
                break;
            }

            final int key = (bytes[pOffset] << 8) | bytes[pOffset + 1];
            final int valueLen = (bytes[pOffset + 2] << 8) | bytes[pOffset + 3];
            pOffset += 4;

            if (pOffset + valueLen > bytes.length) {
                break;
            }

            final value = bytes.sublist(pOffset, pOffset + valueLen);
            encoded[key] = value;
            pOffset += valueLen;
        }

        final Map<String, String> decoded = { };
        for (final entry in encoded.entries) {
            final key = entry.key;
            final value = entry.value;

            // Ejemplos comunes
            switch (key) {
                case 1:
                    decoded['alpn'] = utf8.decode(value, allowMalformed: true);
                    break;
                case 3:
                    decoded['port'] = value.fold(0, (a, b) => (a << 8) + b).toString();
                    break;
                case 4:
                    decoded['ipv4hint'] = value.map((b) => b.toString()).join('.');
                    break;
                case 6:
                    decoded['ipv6hint'] = value
                        .buffer.asUint8List()
                        .map((b) => b.toRadixString(16).padLeft(2, '0'))
                        .join(':')
                        .replaceAll(RegExp(r'(:0+)+(:|$)'), '::');
                    break;
                default:
                    decoded[key.toString()] = value.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
            }
        }

        return SVCBResponseRecord(
            name: name,
            ttl: ttl,
            priority: priority,
            target: target,
            params: decoded);
    }

    @override
    String get type => 'SVCB';

    @override
    String get representation => '$priority $target ${params.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join(' ')}';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'priority': priority,
        'target': target,
        'params': params,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
