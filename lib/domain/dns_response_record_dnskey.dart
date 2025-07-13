import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode, base64;
import './dns_response_record.dart' show DNSResponseRecord;


class DNSKEYResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final int flags;
    final int protocol;
    final int algorithm;
    final Uint8List publicKey;
    final String base64PublicKey;

    DNSKEYResponseRecord({
        required this.name,
        required this.ttl,
        required this.flags,
        required this.protocol,
        required this.algorithm,
        required this.publicKey,
        required this.base64PublicKey,
    }) : super(name: name, ttl: ttl);

    static DNSKEYResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if (length < 4 || (offset + length > bytes.length)) {
            throw FormatException('Invalid DNSKEY record length.');
        }

        final int flags = (bytes[offset] << 8) | bytes[offset + 1];
        final int protocol = bytes[offset + 2];
        final int algorithm = bytes[offset + 3];
        final Uint8List publicKey = bytes.sublist(offset + 4, offset + length);
        final String base64Key = base64.encode(publicKey);

        return DNSKEYResponseRecord(
            name: name,
            ttl: ttl,
            flags: flags,
            protocol: protocol,
            algorithm: algorithm,
            publicKey: publicKey,
            base64PublicKey: base64Key);
    }

    @override
    String get type => 'DNSKEY';

    @override
    String get representation => '$flags $protocol $algorithm $base64PublicKey';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'flags': flags,
        'protocol': protocol,
        'algorithm': algorithm,
        'publicKey': base64PublicKey,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
