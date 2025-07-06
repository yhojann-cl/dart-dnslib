import 'dart:convert' show base64Encode, jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


class SMIMEAResponseRecord extends DNSResponseRecord {
  
    final int usage;
    final int selector;
    final int matchingType;
    final Uint8List certificate;

    SMIMEAResponseRecord({
        required super.name,
        required super.ttl,
        required this.usage,
        required this.selector,
        required this.matchingType,
        required this.certificate,
    });

    static SMIMEAResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if (length < 3 || (offset + length) > bytes.length) {
            throw FormatException('Invalid SMIMEA record: expected at least 3 bytes');
        }

        final int usage = bytes[offset];
        final int selector = bytes[offset + 1];
        final int matchingType = bytes[offset + 2];
        final Uint8List cert = bytes.sublist(offset + 3, offset + length);

        return SMIMEAResponseRecord(
            name: name,
            ttl: ttl,
            usage: usage,
            selector: selector,
            matchingType: matchingType,
            certificate: cert);
    }

    @override
    String get type => 'SMIMEA';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'usage': usage,
        'selector': selector,
        'matchingType': matchingType,
        'certificate': base64Encode(certificate),
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
