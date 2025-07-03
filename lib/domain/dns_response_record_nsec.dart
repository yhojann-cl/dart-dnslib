import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


/**
 *
 */
class NSECResponseRecord extends DNSResponseRecord {
  
    final String nextDomainName;
    final List<int> types;

    NSECResponseRecord({
        required super.name,
        required super.ttl,
        required this.nextDomainName,
        required this.types,
    });

    static NSECResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if ((offset + length) > bytes.length)
            throw FormatException('Invalid NSEC record: RDATA out of range.');

        int i = offset;

        // Leer el nombre del siguiente dominio
        final (newOffset, nextDomainName) = DNSHelper.parseDomainName(bytes, i);
        i = newOffset;

        final List<int> types = [ ];

        // El resto es el bitmap de tipos de registros
        while (i < offset + length) {
            final int blockNumber = bytes[i++];
            final int blockLength = bytes[i++];
            for (int j = 0; j < blockLength; j++) {
                final int byteVal = bytes[i++];
                for (int bit = 0; bit < 8; bit++) {
                    if ((byteVal & (1 << (7 - bit))) != 0) {
                        types.add((blockNumber * 256) + (j * 8 + bit));
                    }
                }
            }
        }

        return NSECResponseRecord(
            name: name,
            ttl: ttl,
            nextDomainName: nextDomainName,
            types: types);
    }

    @override
    String get type => 'NSEC';

    @override
    String toString() => jsonEncode({
        'type': type,
        'name': name,
        'ttl': ttl,
        'nextDomainName': nextDomainName,
        'types': types,
    });
}
