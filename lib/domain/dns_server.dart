import 'dart:convert' show jsonEncode;
import './dns_protocol.dart' show DnsProtocol;


/**
 *
 */
class DnsServer {

    String? name;
    String? description;
    String host;
    int port;
    String path;
    DnsProtocol protocol;
    Map<String, String> headers;

    DnsServer({
        required this.host,
        this.name,
        this.description,
        this.port = 53, // Default port
        this.protocol = DnsProtocol.udp, // Default protocol
        this.path = '/dns-query', // Default path for DoH
        this.headers = const { // Default headers for DoH
            'Accept': 'application/dns-message',
            'Content-Type': 'application/dns-message',
            'Connection': 'close',
        },
    });

    @override
    Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'host': host,
        'port': port,
        'path': path,
        'protocol': protocol.name,
        'headers': headers,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}
