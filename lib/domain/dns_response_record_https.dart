import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode, utf8;
import 'dart:io' show InternetAddress, InternetAddressType;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class HTTPSResponseRecord extends DNSResponseRecord {
  
    final int priority;
    final String targetName;
    final Map<String, String> params;

    HTTPSResponseRecord({
        required String name,
        required int ttl,
        required this.priority,
        required this.targetName,
        required this.params,
    }) : super(name: name, ttl: ttl);

    static HTTPSResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if (length < 3) {
            throw FormatException('Invalid HTTPS record: expected at least 3 bytes, got $length');
        }

        final int priority = (bytes[offset] << 8) | bytes[offset + 1];
        int i = offset + 2;

        // Leer nombre objetivo (targetName)
        final (offs, hostname) = DNSHelper.parseDomainName(bytes, i);
        i = offs;

        final Map<int, Uint8List> encoded = { };
        while (i < offset + length) {
            if (i + 4 > bytes.length) {
                break;
            }

            final int key = (bytes[i] << 8) | bytes[i + 1];
            final int valueLength = (bytes[i + 2] << 8) | bytes[i + 3];
            i += 4;

            if (i + valueLength > bytes.length) {
                break;
            }

            encoded[key] = bytes.sublist(i, i + valueLength);
            i += valueLength;
        }

        final Map<int, String> knownKeys = {
            1: 'alpn',
            3: 'port',
            4: 'ipv4hint',
            6: 'ipv6hint',
        };

        final Map<String, String> decoded = { };
        for (final entry in encoded.entries) {
            final key = entry.key;
            final val = entry.value;
            final name = knownKeys[key] ?? 'key$key';
            late String value;

            switch (key) {
                case 1:
                    value = _decodeAlpn(val);
                    break;
                case 3:
                    value = _decodePort(val);
                    break;
                case 4:
                    value = _decodeIPv4Hint(val);
                    break;
                case 6:
                    value = _decodeIPv6Hint(val);
                    break;
                default:
                    value = val.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
            }

            decoded[name] = value;
        }

        return HTTPSResponseRecord(
            name: name,
            ttl: ttl,
            priority: priority,
            targetName: hostname,
            params: decoded);
    }

    static String _decodeAlpn(Uint8List value) {
        final List<String> protocols = [ ];
        int i = 0;
        while (i < value.length) {
            final len = value[i];
            i++;
            if (i + len > value.length) {
                break;
            }

            final name = utf8.decode(value.sublist(i, i + len));
            protocols.add(name);
            i += len;
        }
        return protocols.join(',');
    }

    static String _decodeIPv4Hint(Uint8List value) {
        final List<String> ips = [];
        for (int i = 0; i + 4 <= value.length; i += 4) {
            final ip = InternetAddress.fromRawAddress(value.sublist(i, i + 4)).address;
            ips.add(ip);
        }
        return ips.join(', ');
    }

    static String _decodeIPv6Hint(Uint8List value) {
        final List<String> ips = [];
        for (int i = 0; i + 16 <= value.length; i += 16) {
            final ip = InternetAddress.fromRawAddress(value.sublist(i, i + 16), type: InternetAddressType.IPv6).address;
            ips.add(ip);
        }
        return ips.join(', ');
    }

    static String _decodePort(Uint8List value) {
        if (value.length != 2) {
            return 'invalid';
        }
        return ((value[0] << 8) | value[1]).toString();
    }

    @override
    String get type => 'HTTPS';

    @override
    String get representation => '$priority $targetName ${params.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join(' ')}';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'priority': priority,
        'target': targetName,
        'params': params,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
