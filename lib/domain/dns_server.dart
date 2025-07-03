import 'dart:convert';
import './dns_protocol.dart' show DnsProtocol;


/**
 *
 */
class DnsServer {

    final String host;
    final int port;
    final String path;
    final DnsProtocol protocol;
    final Map<String, String> headers;

    const DnsServer({
        required this.host,
        this.port = 53, // Default port
        this.protocol = DnsProtocol.udp, // Default protocol
        this.path = '/dns-query', // Default path
        this.headers = const { // Default headers
            'Accept': 'application/dns-message',
            'Content-Type': 'application/dns-message',
            'Connection': 'close',
        },
    });

    @override
    String toString() => jsonEncode({
        'host': host,
        'port': port,
        'path': path,
        'protocol': protocol.name,
        'headers': headers,
    });
}
