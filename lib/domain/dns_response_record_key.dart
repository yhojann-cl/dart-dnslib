import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode, base64;
import './dns_response_record.dart' show DNSResponseRecord;


class KEYResponseRecord extends DNSResponseRecord {
  
    final int flags;
    final int protocol;
    final int algorithm;
    final Uint8List publicKey;

    KEYResponseRecord({
        required String name,
        required int ttl,
        required this.flags,
        required this.protocol,
        required this.algorithm,
        required this.publicKey,
    }) : super(name: name, ttl: ttl);

    static KEYResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length < 4 || (offset + 4) > bytes.length)  {
            throw FormatException('Invalid KEY record: too short');
        }

        final int flags = (bytes[offset] << 8) | bytes[offset + 1];
        final int protocol = bytes[offset + 2];
        final int algorithm = bytes[offset + 3];
        final Uint8List publicKey = bytes.sublist(offset + 4, offset + length);

        return KEYResponseRecord(
            name: name,
            ttl: ttl,
            flags: flags,
            protocol: protocol,
            algorithm: algorithm,
            publicKey: publicKey);
    }

    @override
    String get type => 'KEY';

    @override
    String get representation => '$flags $protocol $algorithm ${base64.encode(publicKey)}';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'flags': flags,
        'protocol': protocol,
        'algorithm': algorithm,
        'publicKey': base64.encode(publicKey),
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
