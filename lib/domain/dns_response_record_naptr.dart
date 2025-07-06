import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode, utf8;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class NAPTRResponseRecord extends DNSResponseRecord {
  
    final int order;
    final int preference;
    final String flags;
    final String services;
    final String regexp;
    final String replacement;

    NAPTRResponseRecord({
        required super.name,
        required super.ttl,
        required this.order,
        required this.preference,
        required this.flags,
        required this.services,
        required this.regexp,
        required this.replacement,
    });

    static NAPTRResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        if ((offset + length) > bytes.length || length < 7) {
            throw FormatException('Invalid NAPTR record: incorrect length.');
        }

        final int order = (bytes[offset] << 8) | bytes[offset + 1];
        final int preference = (bytes[offset + 2] << 8) | bytes[offset + 3];
        offset += 4;

        final int flagsLen = bytes[offset++];
        final String flags = utf8.decode(bytes.sublist(offset, offset + flagsLen));
        offset += flagsLen;

        final int servicesLen = bytes[offset++];
        final String services = utf8.decode(bytes.sublist(offset, offset + servicesLen));
        offset += servicesLen;

        final int regexpLen = bytes[offset++];
        final String regexp = utf8.decode(bytes.sublist(offset, offset + regexpLen));
        offset += regexpLen;

        final (_, String replacement) = DNSHelper.parseDomainName(bytes, offset);

        return NAPTRResponseRecord(
            name: name,
            ttl: ttl,
            order: order,
            preference: preference,
            flags: flags,
            services: services,
            regexp: regexp,
            replacement: replacement);
    }

    @override
    String get type => 'NAPTR';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'order': order,
        'preference': preference,
        'flags': flags,
        'services': services,
        'regexp': regexp,
        'replacement': replacement,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
