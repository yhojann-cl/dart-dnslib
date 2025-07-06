import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode;
import './dns_response_record.dart' show DNSResponseRecord;


class DLVResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final int keyTag;
    final int algorithm;
    final int digestType;
    final Uint8List digest;
    final String hexDigest;

    DLVResponseRecord({
        required this.name,
        required this.ttl,
        required this.keyTag,
        required this.algorithm,
        required this.digestType,
        required this.digest,
        required this.hexDigest,
    }) : super(name: name, ttl: ttl);

    static DLVResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length < 4 || (offset + length > bytes.length)) {
            throw FormatException('Invalid DLV record: insufficient data.');
        }

        final int keyTag = (bytes[offset] << 8) | bytes[offset + 1];
        final int algorithm = bytes[offset + 2];
        final int digestType = bytes[offset + 3];
        final Uint8List digest = bytes.sublist(offset + 4, offset + length);

        final String hex = digest
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join();

        return DLVResponseRecord(
            name: name,
            ttl: ttl,
            keyTag: keyTag,
            algorithm: algorithm,
            digestType: digestType,
            digest: digest,
            hexDigest: hex);
    }

    @override
    String get type => 'DLV';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'keyTag': keyTag,
        'algorithm': algorithm,
        'digestType': digestType,
        'hexDigest': hexDigest,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
