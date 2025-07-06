import 'dart:convert' show jsonEncode;
import 'dart:io' show InternetAddress;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


class AResponseRecord extends DNSResponseRecord {
    
    final String name;
    final int ttl;
    final InternetAddress ip;

    AResponseRecord({
        required this.name,
        required this.ip,
        required this.ttl,
    }) : super(name: name, ttl: ttl);

    static AResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        // Length validation
        if((length != 4) || ((offset + length) > bytes.length)) {
            throw FormatException('Invalid bytes length for A record.');
        }

        // Create the IPv4
        final String ipString = bytes
            .sublist(offset, offset + length)
            .join('.');

        // Create instance
        return AResponseRecord(
            name: name,
            ttl: ttl,
            ip: InternetAddress.tryParse(ipString)!
        );
    }
    
    @override
    String get type => 'A';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'ip': {
            'host': ip.host,
            'address': ip.address,
            'isLinkLocal': ip.isLinkLocal,
            'isLoopback': ip.isLoopback,
            'isMulticast': ip.isMulticast,
            'type': ip.type.name,
        }
    };

    @override
    String toString() => jsonEncode(toJson());
}