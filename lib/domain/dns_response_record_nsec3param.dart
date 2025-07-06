import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


class NSEC3PARAMResponseRecord extends DNSResponseRecord {
  
    final int hashAlgorithm;
    final int flags;
    final int iterations;
    final Uint8List salt;

    NSEC3PARAMResponseRecord({
        required super.name,
        required super.ttl,
        required this.hashAlgorithm,
        required this.flags,
        required this.iterations,
        required this.salt,
    });

    static NSEC3PARAMResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if ((offset + length) > bytes.length || length < 5) {
            throw FormatException('Invalid NSEC3PARAM record: insufficient length.');
        }

        final int hashAlgorithm = bytes[offset];
        final int flags = bytes[offset + 1];
        final int iterations = (bytes[offset + 2] << 8) | bytes[offset + 3];
        final int saltLength = bytes[offset + 4];

        if (offset + 5 + saltLength > bytes.length) {
            throw FormatException('Invalid NSEC3PARAM record: salt data out of range.');
        }

        final Uint8List salt = bytes.sublist(offset + 5, offset + 5 + saltLength);

        return NSEC3PARAMResponseRecord(
            name: name,
            ttl: ttl,
            hashAlgorithm: hashAlgorithm,
            flags: flags,
            iterations: iterations,
            salt: salt);
    }

    @override
    String get type => 'NSEC3PARAM';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'hashAlgorithm': hashAlgorithm,
        'flags': flags,
        'iterations': iterations,
        'salt': salt // To hex string
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(),
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
