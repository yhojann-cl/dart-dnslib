import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode;
import './dns_response_record.dart' show DNSResponseRecord;


class EUI64ResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final Uint8List macBytes;
    final String macAddress;

    EUI64ResponseRecord({
        required this.name,
        required this.ttl,
        required this.macBytes,
        required this.macAddress,
    }) : super(name: name, ttl: ttl);

    static EUI64ResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length != 8 || offset + 8 > bytes.length) {
            throw FormatException('Invalid EUI-48 record: expected 6 bytes, got $length.');
        }

        final Uint8List mac = bytes.sublist(offset, offset + 8);
        final String macStr = mac.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join('-');

        return EUI64ResponseRecord(
            name: name,
            ttl: ttl,
            macBytes: mac,
            macAddress: macStr);
    }

    @override
    String get type => 'EUI64';

    @override
    String get representation => macAddress;

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
