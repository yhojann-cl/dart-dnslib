/**
 *
 */
abstract class DNSResponseRecord {
    
    final String name;
    final int ttl;

    DNSResponseRecord({
        required this.name,
        required this.ttl,
    });

    String get type;
}