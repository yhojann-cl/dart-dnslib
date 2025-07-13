import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


class SSHFPResponseRecord extends DNSResponseRecord {
  
    final int algorithm;
    final int fingerprintType;
    final Uint8List fingerprint;

    SSHFPResponseRecord({
        required super.name,
        required super.ttl,
        required this.algorithm,
        required this.fingerprintType,
        required this.fingerprint,
    });

    static SSHFPResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if (length < 2 || (offset + length) > bytes.length) {
            throw FormatException('Invalid SSHFP record: too short or out of range');
        }

        final int algorithm = bytes[offset];
        final int fingerprintType = bytes[offset + 1];
        final Uint8List fingerprint = bytes.sublist(offset + 2, offset + length);

        return SSHFPResponseRecord(
            name: name,
            ttl: ttl,
            algorithm: algorithm,
            fingerprintType: fingerprintType,
            fingerprint: fingerprint);
    }

    @override
    String get type => 'SSHFP';

    @override
    String get representation => '$algorithm $fingerprintType ${fingerprint
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join('')}';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'algorithm': algorithm,
        'fingerprintType': fingerprintType,
        'fingerprint': fingerprint
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(''),
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
