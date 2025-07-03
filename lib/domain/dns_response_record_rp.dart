import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


/**
 *
 */
class RPResponseRecord extends DNSResponseRecord {
  
    final String mboxDName; // Correo como nombre de dominio (ej: host\\.admin.example.com)
    final String txtDName;  // Nombre de dominio con más info

    RPResponseRecord({
        required super.name,
        required super.ttl,
        required this.mboxDName,
        required this.txtDName,
    });

    static RPResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        if ((offset + length) > bytes.length)
            throw FormatException('Invalid RP record: insufficient bytes.');

        final (offset1, mboxDName) = DNSHelper.parseDomainName(bytes, offset);
        final (_, txtDName) = DNSHelper.parseDomainName(bytes, offset1);

        return RPResponseRecord(
            name: name,
            ttl: ttl,
            mboxDName: mboxDName,
            txtDName: txtDName);
    }

    @override
    String get type => 'RP';

    @override
    String toString() => jsonEncode({
        'type': type,
        'name': name,
        'ttl': ttl,
        'mboxDName': mboxDName,
        'txtDName': txtDName,
    });
}
