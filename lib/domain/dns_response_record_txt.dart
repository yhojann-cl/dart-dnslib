import 'dart:convert' show jsonEncode, utf8;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


/**
 *
 */
class TXTResponseRecord extends DNSResponseRecord {
  
    final List<String> texts;

    TXTResponseRecord({
        required super.name,
        required super.ttl,
        required this.texts,
    });

    static TXTResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if (offset + length > bytes.length)
            throw FormatException('TXT record out of bounds');

        final List<String> texts = [];
        int i = offset;
        final int end = offset + length;

        while (i < end) {
            final int len = bytes[i];
            i += 1;

            if (i + len > end)
                throw FormatException('Invalid TXT string length');

            final String txt = utf8.decode(bytes.sublist(i, i + len));
            texts.add(txt);
            i += len;
        }

        return TXTResponseRecord(
            name: name,
            ttl: ttl,
            texts: texts);
    }

    @override
    String get type => 'TXT';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'texts': texts,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
