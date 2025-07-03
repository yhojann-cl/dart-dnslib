import 'dart:convert' show jsonEncode, base64Encode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


/**
 *
 */
class DHCIDResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final int identifierType;
    final int digestAlgorithm;
    final Uint8List identifier;
    final String base64;

    DHCIDResponseRecord({
        required this.name,
        required this.ttl,
        required this.identifierType,
        required this.digestAlgorithm,
        required this.identifier,
        required this.base64,
    }) : super(name: name, ttl: ttl);

    static DHCIDResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if ((length < 3) ||
            (offset + length > bytes.length))
            throw FormatException('Invalid DHCID record: length too short or out of bounds');

        final int idType = (bytes[offset] << 8) | bytes[offset + 1];
        final int digestAlg = bytes[offset + 2];
        final Uint8List identifier = bytes.sublist(offset + 3, offset + length);
        final String base64String = base64Encode(bytes.sublist(offset, offset + length));

        return DHCIDResponseRecord(
            name: name,
            ttl: ttl,
            identifierType: idType,
            digestAlgorithm: digestAlg,
            identifier: identifier,
            base64: base64String);
    }

    @override
    String get type => 'DHCID';

    @override
    String toString() => jsonEncode({
        'type': type,
        'name': name,
        'ttl': ttl,
        'identifierType': identifierType,
        'digestAlgorithm': digestAlgorithm,
        'base64': base64,
    });
}
