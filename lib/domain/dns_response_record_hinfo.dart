import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode;
import './dns_response_record.dart' show DNSResponseRecord;


/**
 *
 */
class HINFOResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final String cpu;
    final String os;

    HINFOResponseRecord({
        required this.name,
        required this.ttl,
        required this.cpu,
        required this.os,
    }) : super(name: name, ttl: ttl);

    static HINFOResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        final int end = offset + length;
        if (end > bytes.length)
            throw FormatException('Invalid HINFO record: not enough bytes.');

        // Parse CPU
        final int cpuLen = bytes[offset];
        offset += 1;
        if (offset + cpuLen > end)
        throw FormatException('Invalid HINFO: CPU length out of bounds.');
        
        final String cpu = String.fromCharCodes(bytes.sublist(offset, offset + cpuLen));
        offset += cpuLen;

        // Parse OS
        if (offset >= end)
            throw FormatException('Invalid HINFO: no OS field.');

        final int osLen = bytes[offset];
        offset += 1;
        if (offset + osLen > end)
            throw FormatException('Invalid HINFO: OS length out of bounds.');
        
        final String os = String.fromCharCodes(bytes.sublist(offset, offset + osLen));

        return HINFOResponseRecord(
            name: name,
            ttl: ttl,
            cpu: cpu,
            os: os);
    }

    @override
    String get type => 'HINFO';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'cpu': cpu,
        'os': os,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
