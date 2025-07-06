import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode;
import './dns_response_record.dart' show DNSResponseRecord;
import '../helper/dns.dart' show DNSHelper;


class HIPResponseRecord extends DNSResponseRecord {
  
    final String name;
    final int ttl;
    final int hitLength;
    final int algorithm;
    final int pkLength;
    final Uint8List hit;
    final Uint8List publicKey;
    final List<String> rendezvousServers;

    HIPResponseRecord({
        required this.name,
        required this.ttl,
        required this.hitLength,
        required this.algorithm,
        required this.pkLength,
        required this.hit,
        required this.publicKey,
        required this.rendezvousServers,
    }) : super(name: name, ttl: ttl);

    static HIPResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {

        final int end = offset + length;
        if (end > bytes.length) {
            throw FormatException('HIP record overflow');
        }

        final int hitLength = bytes[offset];
        final int algorithm = bytes[offset + 1];
        final int pkLength = (bytes[offset + 2] << 8) | bytes[offset + 3];

        final int posHit = offset + 4;
        final int posPK = posHit + hitLength;
        final int posRendezvous = posPK + pkLength;

        if (posRendezvous > end) {
            throw FormatException('HIP record truncated');
        }

        final hit = bytes.sublist(posHit, posPK);
        final publicKey = bytes.sublist(posPK, posRendezvous);

        // Parse rendezvous servers
        final List<String> servers = [];
        int ptr = posRendezvous;
        while (ptr < end) {
            late String server;
            (ptr, server) = DNSHelper.parseDomainName(bytes, ptr);
            servers.add(server);
        }

        return HIPResponseRecord(
            name: name,
            ttl: ttl,
            hitLength: hitLength,
            algorithm: algorithm,
            pkLength: pkLength,
            hit: hit,
            publicKey: publicKey,
            rendezvousServers: servers);
    }

    @override
    String get type => 'HIP';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'algorithm': algorithm,
        'hit': hit // to hex
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(''),
        'pk': publicKey // to hex
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(''),
        'rendezvous': rendezvousServers,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
