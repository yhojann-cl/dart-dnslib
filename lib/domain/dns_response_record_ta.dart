import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;



/**
 *
 */
class TAResponseRecord extends DNSResponseRecord {

    final int flags;
    final int protocol;
    final int algorithm;
    final Uint8List publicKey;

    TAResponseRecord({
        required super.name,
        required super.ttl,
        required this.flags,
        required this.protocol,
        required this.algorithm,
        required this.publicKey,
    });

    static TAResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if ((offset + length) > bytes.length || length < 4)
            throw FormatException('Invalid TA record');

        final int flags = (bytes[offset] << 8) | bytes[offset + 1];
        final int protocol = bytes[offset + 2];
        final int algorithm = bytes[offset + 3];

        final Uint8List publicKey = bytes.sublist(offset + 4, offset + length);

        return TAResponseRecord(
            name: name,
            ttl: ttl,
            flags: flags,
            protocol: protocol,
            algorithm: algorithm,
            publicKey: publicKey);
    }

    @override
    String get type => 'TA';

    @override
    String toString() => jsonEncode({
        'type': type,
        'name': name,
        'ttl': ttl,
        'flags': flags,
        'protocol': protocol,
        'algorithm': algorithm,
        'publicKey': publicKey
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(''),
    });
}
