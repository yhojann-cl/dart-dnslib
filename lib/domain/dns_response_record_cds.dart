import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


/**
 *
 */
class CDSResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final int keyTag;
    final int algorithm;
    final int digestType;
    final Uint8List digest;

    CDSResponseRecord({
        required this.name,
        required this.ttl,
        required this.keyTag,
        required this.algorithm,
        required this.digestType,
        required this.digest,
    }) : super(name: name, ttl: ttl);

    static CDSResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length < 4)
            throw FormatException('Invalid CDS record: too short');

        final int keyTag = (bytes[offset] << 8) | bytes[offset + 1];
        final int algorithm = bytes[offset + 2];
        final int digestType = bytes[offset + 3];
        final Uint8List digest = bytes.sublist(offset + 4, offset + length);

        return CDSResponseRecord(
            name: name,
            ttl: ttl,
            keyTag: keyTag,
            algorithm: algorithm,
            digestType: digestType,
            digest: digest);
    }

    @override
    String get type => 'CDS';

    @override
    String toString() => jsonEncode({
        'type': type,
        'name': name,
        'ttl': ttl,
        'keyTag': keyTag,
        'algorithm': algorithm,
        'digestType': digestType,
        'digest': digest
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(''),
    });
}
