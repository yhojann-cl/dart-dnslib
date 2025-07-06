import 'dart:convert' show jsonEncode;
import './dns_protocol.dart' show DNSProtocol;


class DNSServer {

    String? name;
    String? description;
    String host;
    int port;
    String path;
    DNSProtocol protocol;
    Map<String, String> headers;

    DNSServer({
        required this.host,
        this.name,
        this.description,
        this.port = 53, // Default port
        this.protocol = DNSProtocol.udp, // Default protocol
        this.path = '/dns-query', // Default path for DoH
        this.headers = const { // Default headers for DoH
            'Accept': 'application/dns-message',
            'Content-Type': 'application/dns-message',
            'Connection': 'close',
        },
    });

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
