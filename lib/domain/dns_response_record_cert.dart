import 'dart:convert' show jsonEncode, base64;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


class CERTResponseRecord extends DNSResponseRecord {

    final String name;
    final int ttl;
    final int certificateType; // 2 bytes
    final int keyTag;          // 2 bytes
    final int algorithm;       // 1 byte
    final Uint8List certificate;

    CERTResponseRecord({
        required this.name,
        required this.ttl,
        required this.certificateType,
        required this.keyTag,
        required this.algorithm,
        required this.certificate,
    }) : super(name: name, ttl: ttl);

    static CERTResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length < 5 || (offset + length) > bytes.length) {
            throw FormatException('Invalid CERT record: too short or out of bounds.');
        }

        final int certType = (bytes[offset] << 8) | bytes[offset + 1];
        final int keyTag = (bytes[offset + 2] << 8) | bytes[offset + 3];
        final int algorithm = bytes[offset + 4];
        final Uint8List certData = bytes.sublist(offset + 5, offset + length);

        return CERTResponseRecord(
            name: name,
            ttl: ttl,
            certificateType: certType,
            keyTag: keyTag,
            algorithm: algorithm,
            certificate: certData);
    }

    @override
    String get type => 'CERT';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'certificateType': certificateType,
        'keyTag': keyTag,
        'algorithm': algorithm,
        'certificate': base64.encode(certificate),
    };
    
    @override
    String toString() => jsonEncode(toJson());
}