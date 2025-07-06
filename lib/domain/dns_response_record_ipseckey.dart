import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode, base64;
import 'dart:io' show InternetAddress, InternetAddressType;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class IPSECKEYResponseRecord extends DNSResponseRecord {
  
    final int precedence;
    final int gatewayType;
    final int algorithm;
    final String gateway;
    final Uint8List publicKey;

    IPSECKEYResponseRecord({
        required String name,
        required int ttl,
        required this.precedence,
        required this.gatewayType,
        required this.algorithm,
        required this.gateway,
        required this.publicKey,
    }) : super(name: name, ttl: ttl);

    static IPSECKEYResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length < 3 || offset + 3 > bytes.length) {
            throw FormatException('Invalid IPSECKEY record: too short.');
        }

        final int precedence = bytes[offset];
        final int gatewayType = bytes[offset + 1];
        final int algorithm = bytes[offset + 2];
        int i = offset + 3;

        String gateway = '';
        if (gatewayType == 0) {
            gateway = '.';

        } else if (gatewayType == 1) {
            if (i + 4 > bytes.length) {
                throw FormatException('Invalid IPv4 gateway in IPSECKEY');
            }
            
            gateway = InternetAddress.fromRawAddress(bytes.sublist(i, i + 4)).address;
            i += 4;

        } else if (gatewayType == 2) {
            if (i + 16 > bytes.length) {
                throw FormatException('Invalid IPv6 gateway in IPSECKEY');
            }

            gateway = InternetAddress.fromRawAddress(bytes.sublist(i, i + 16), type: InternetAddressType.IPv6).address;
            i += 16;

        } else if (gatewayType == 3) {
            final (offs, hostname) = DNSHelper.parseDomainName(bytes, i);
            i = offs;
            gateway = hostname;

        } else {
            throw FormatException('Unknown gateway type in IPSECKEY: $gatewayType');
        }

        final Uint8List publicKey = (i < offset + length)
            ? bytes.sublist(i, offset + length)
            : Uint8List(0);

        return IPSECKEYResponseRecord(
            name: name,
            ttl: ttl,
            precedence: precedence,
            gatewayType: gatewayType,
            algorithm: algorithm,
            gateway: gateway,
            publicKey: publicKey);
    }

    @override
    String get type => 'IPSECKEY';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'precedence': precedence,
        'gatewayType': gatewayType,
        'algorithm': algorithm,
        'gateway': gateway,
        'publicKey': base64.encode(publicKey),
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
