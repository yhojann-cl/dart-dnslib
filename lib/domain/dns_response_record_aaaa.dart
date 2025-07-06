import 'dart:convert' show jsonEncode;
import 'dart:io' show InternetAddress;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;


class AAAAResponseRecord extends DNSResponseRecord {
    
    final String name;
    final int ttl;
    final InternetAddress ip;

    AAAAResponseRecord({
        required this.name,
        required this.ip,
        required this.ttl,
    }) : super(name: name, ttl: ttl);

    static AAAAResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        // Length validation
        if((length != 16) || ((offset + length) > bytes.length)) {
            throw FormatException('Invalid bytes length for A record.');
        }

        // Create the IPv6
        final String ipString = Iterable<String>.generate(8, (i) {
            final int high = bytes[offset + (i * 2)];
            final int low = bytes[offset + ((i * 2) + 1)];
            return '${high.toRadixString(16).padLeft(2, '0')}${low.toRadixString(16).padLeft(2, '0')}';
        })
        .join(':')
        .replaceAllMapped(RegExp(r'(:0+)+(:|$)'), (match) => '::');

        // Create instance
        return AAAAResponseRecord(
            name: name,
            ttl: ttl,
            ip: InternetAddress.tryParse(ipString)!
        );
    }
    
    @override
    String get type => 'AAAA';

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