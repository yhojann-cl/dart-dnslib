import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import 'dart:io' show InternetAddress, InternetAddressType;
import './dns_response_record.dart' show DNSResponseRecord;


/**
 *
 */
class APLPrefix {
    final int family;
    final int prefix;
    final bool negation;
    final InternetAddress ip;

    APLPrefix({
        required this.family,
        required this.prefix,
        required this.negation,
        required this.ip,
    });

    @override
    Map<String, dynamic> toJson() => {
        'family': family,
        'prefix': prefix,
        'negation': negation,
        'ip': {
            'host': ip.host,
            'address': ip.address,
            'isLinkLocal': ip.isLinkLocal,
            'isLoopback': ip.isLoopback,
            'isMulticast': ip.isMulticast,
            'type': ip.type.name,
        },
        'alias': '${negation ? '!' : ''}${family}:${ip.address}/${prefix}'
    };

    @override
    String toString() => jsonEncode(toJson());
}


/**
 *
 */
class APLResponseRecord extends DNSResponseRecord {

    final String name;
    final int ttl;
    final List<APLPrefix> prefixes;

    APLResponseRecord({
        required this.name,
        required this.ttl,
        required this.prefixes,
    }) : super(name: name, ttl: ttl);

    static APLResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        final List<APLPrefix> prefixes = [ ];
        int cursor = offset;

        while (cursor < offset + length) {
            if (cursor + 4 > bytes.length)
                throw FormatException('Truncated APL entry at offset $cursor');

            final int family = (bytes[cursor] << 8) | bytes[cursor + 1];
            final int prefix = bytes[cursor + 2];
            final int lengthAndNegation = bytes[cursor + 3];
            final bool negation = (lengthAndNegation & 0x80) != 0;
            final int afdLength = lengthAndNegation & 0x7F;
            cursor += 4;

            if (cursor + afdLength > bytes.length)
                throw FormatException('Invalid AFD length at offset $cursor');

            final Uint8List afdBytes = bytes.sublist(cursor, cursor + afdLength);
            cursor += afdLength;

            final InternetAddress ip = InternetAddress.fromRawAddress(
                _padAddress(afdBytes, family),
                type: family == 1
                    ? InternetAddressType.IPv4
                    : InternetAddressType.IPv6,
            );

            prefixes.add(APLPrefix(
                family: family,
                prefix: prefix,
                negation: negation,
                ip: ip,
            ));
        }

        return APLResponseRecord(
            name: name,
            ttl: ttl,
            prefixes: prefixes);
    }

    static Uint8List _padAddress(Uint8List input, int family) {
        final int targetLength = (family == 1) ? 4 : 16;
        final result = Uint8List(targetLength);
        for (int i = 0; i < input.length; i++)
            result[i] = input[i];
        return result;
    }

    @override
    String get type => 'APL';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'prefixes': prefixes.map((p) => p.toJson()),
    };

    @override
    String toString() => jsonEncode(toJson());
}