import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode;
import './dns_response_record.dart' show DNSResponseRecord;


class EUI48ResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final Uint8List macBytes;
    final String macAddress;

    EUI48ResponseRecord({
        required this.name,
        required this.ttl,
        required this.macBytes,
        required this.macAddress,
    }) : super(name: name, ttl: ttl);

    static EUI48ResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length != 6 || offset + 6 > bytes.length) {
            throw FormatException('Invalid EUI-48 record: expected 6 bytes, got $length.');
        }

        final Uint8List mac = bytes.sublist(offset, offset + 6);
        final String macStr = mac.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join('-');

        return EUI48ResponseRecord(
            name: name,
            ttl: ttl,
            macBytes: mac,
            macAddress: macStr);
    }

    @override
    String get type => 'EUI48';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'macAddress': macAddress,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
