import 'dart:convert' show jsonEncode;
import 'dart:typed_data' show Uint8List;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class SOAResponseRecord extends DNSResponseRecord {
  
    final String mname;
    final String rname;
    final int serial;
    final int refresh;
    final int retry;
    final int expire;
    final int minimum;

    SOAResponseRecord({
        required super.name,
        required super.ttl,
        required this.mname,
        required this.rname,
        required this.serial,
        required this.refresh,
        required this.retry,
        required this.expire,
        required this.minimum,
    });

    static SOAResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
    
        final int end = offset + length;
        if (end > bytes.length) {
            throw FormatException('Invalid SOA record: insufficient bytes');
        }

        // mname
        final (offset1, mname) = DNSHelper.parseDomainName(bytes, offset);
        
        // rname
        final (offset2, rname) = DNSHelper.parseDomainName(bytes, offset1);

        // Read the 5 uint32 fields
        int readUint32(int o) => (bytes[o] << 24) | (bytes[o + 1] << 16) | (bytes[o + 2] << 8) | bytes[o + 3];

        final int serial   = readUint32(offset2);
        final int refresh  = readUint32(offset2 + 4);
        final int retry    = readUint32(offset2 + 8);
        final int expire   = readUint32(offset2 + 12);
        final int minimum  = readUint32(offset2 + 16);

        return SOAResponseRecord(
            name: name,
            ttl: ttl,
            mname: mname,
            rname: rname,
            serial: serial,
            refresh: refresh,
            retry: retry,
            expire: expire,
            minimum: minimum);
    }

    @override
    String get type => 'SOA';

    @override
    String get representation => '$mname $rname $serial $refresh $retry $expire $minimum';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'mname': mname,
        'rname': rname,
        'serial': serial,
        'refresh': refresh,
        'retry': retry,
        'expire': expire,
        'minimum': minimum,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
