import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


/**
 *
 */
class CAAResponseRecord extends DNSResponseRecord {

    final String name;
    final int ttl;
    final int flags;
    final String tag;
    final String value;

    CAAResponseRecord({
        required this.name,
        required this.ttl,
        required this.flags,
        required this.tag,
        required this.value,
    }) : super(name: name, ttl: ttl);

    static CAAResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if (length < 2)
            throw FormatException('Invalid CAA record: too short');

        final int flags = bytes[offset];
        final int tagLength = bytes[offset + 1];

        if (length < 2 + tagLength)
            throw FormatException('Invalid CAA record: tagLength overflow');

        final String tag = String.fromCharCodes(bytes.sublist(offset + 2, offset + 2 + tagLength));
        final String value = String.fromCharCodes(bytes.sublist(offset + 2 + tagLength, offset + length));

        return CAAResponseRecord(
            name: name,
            ttl: ttl,
            flags: flags,
            tag: tag,
            value: value);
    }

    @override
    String get type => 'CAA';

    @override
    String toString() => jsonEncode({
        'type': type,
        'name': name,
        'ttl': ttl,
        'flags': flags,
        'tag': tag,
        'value': value,
    });
}
