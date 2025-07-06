import '../domain/dns_server.dart' show DNSServer;
import '../domain/dns_protocol.dart' show DNSProtocol;


class DNSServers {

    static List<DNSServer> servers = [
        DNSServer(
            name: 'Google NS1',
            description: 'Public primary Name Server of Google without filters but with access speed restrictions.',
            protocol: DNSProtocol.udp,
            host: '8.8.8.8',
            port: 53,
        ),
        DNSServer(
            name: 'Google NS2',
            description: 'Public secondary Name Server of Google without filters but with access speed restrictions.',
            protocol: DNSProtocol.udp,
            host: '8.8.4.4',
            port: 53,
        ),
        DNSServer(
            name: 'Google DoH',
            description: 'Public DNS over HTTPS (DoH) server of Google.',
            protocol: DNSProtocol.doh,
            host: 'dns.google',
            port: 443,
        ),
        DNSServer(
            name: 'Cloudflare NS1',
            description: 'Public primary Name Server of Cloudflare without filters.',
            protocol: DNSProtocol.udp,
            host: '1.1.1.1',
            port: 53,
        ),
        DNSServer(
            name: 'Cloudflare NS2',
            description: 'Public secondary Name Server of Cloudflare without filters.',
            protocol: DNSProtocol.udp,
            host: '1.0.0.1',
            port: 53,
        ),
        DNSServer(
            name: 'Cloudflare DoH',
            description: 'Cloudflare DNS over HTTPS endpoint.',
            protocol: DNSProtocol.doh,
            host: 'cloudflare-dns.com',
            port: 443,
        ),
        DNSServer(
            name: 'Comodo NS1',
            description: 'Public primary Name Server of Comodo without filters. Use is limited to 300.000 monthly resolutions.',
            protocol: DNSProtocol.udp,
            host: '8.26.56.26',
            port: 53,
        ),
        DNSServer(
            name: 'Comodo NS2',
            description: 'Public secondary Name Server of Comodo without filters. Use is limited to 300.000 monthly resolutions.',
            protocol: DNSProtocol.udp,
            host: '8.20.247.20',
            port: 53,
        ),
        DNSServer(
            name: 'Verisign NS1',
            protocol: DNSProtocol.udp,
            host: '64.6.64.6',
            port: 53,
            description: 'Public primary Name Server of Verisign.'
        ),
        DNSServer(
            name: 'Verisign NS2',
            description: 'Public secondary Name Server of Verisign.',
            protocol: DNSProtocol.udp,
            host: '64.6.65.6',
            port: 53,
        ),
        DNSServer(
            name: 'DNS.Watch NS1',
            description: 'Public primary Name Server of DNS.Watch.',
            protocol: DNSProtocol.udp,
            host: '84.200.69.80',
            port: 53,
        ),
        DNSServer(
            name: 'DNS.Watch NS2',
            description: 'Public secondary Name Server of DNS.Watch.',
            protocol: DNSProtocol.udp,
            host: '84.200.70.40',
            port: 53,
        ),
        DNSServer(
            name: 'OpenDNS NS1',
            description: 'Public primary Name Server of OpenDNS with filters.',
            protocol: DNSProtocol.udp,
            host: '208.67.222.222',
            port: 53,
        ),
        DNSServer(
            name: 'OpenDNS NS2',
            description: 'Public secondary Name Server of OpenDNS with filters.',
            protocol: DNSProtocol.udp,
            host: '208.67.220.220',
            port: 53,
        ),
        DNSServer(
            name: 'Oracle Dyn NS1',
            description: 'Public primary Name Server of Oracle Dyn without filters.',
            protocol: DNSProtocol.udp,
            host: '216.146.35.35',
            port: 53,
        ),
        DNSServer(
            name: 'Oracle Dyn NS2',
            description: 'Public secondary Name Server of Oracle Dyn without filters.',
            protocol: DNSProtocol.udp,
            host: '216.146.36.36',
            port: 53,
        ),
        DNSServer(
            name: 'IBM Quad9 NS1',
            description: 'Public secondary Name Server of IBM Quad9.',
            protocol: DNSProtocol.udp,
            host: '9.9.9.9',
            port: 53,
        ),
        DNSServer(
            name: 'IBM Quad9 DoH',
            description: 'Quad9 DNS over HTTPS endpoint with malware blocking.',
            protocol: DNSProtocol.doh,
            host: 'dns.quad9.net',
            port: 443,
        ),
        DNSServer(
            name: 'Level 3 (Centrulink) NS1',
            description: 'Public primary Name Server of Centrulink (Underwater internet cable provider).',
            protocol: DNSProtocol.udp,
            host: '4.2.2.2',
            port: 53,
        ),
        DNSServer(
            name: 'Level 3 (Centrulink) NS2',
            description: 'Public secondary Name Server of Centrulink (Underwater internet cable provider).',
            protocol: DNSProtocol.udp,
            host: '4.2.2.3',
            port: 53,
        ),
        DNSServer(
            name: 'Level 3 (Centrulink) NS3',
            description: 'Public third Name Server of Centrulink (Underwater internet cable provider).',
            protocol: DNSProtocol.udp,
            host: '4.2.2.4',
            port: 53,
        ),
        DNSServer(
            name: 'Digitalcourage NS1',
            description: 'DNS server from Digitalcourage with no logging.',
            protocol: DNSProtocol.udp,
            host: '46.182.19.48',
            port: 53,
        ),
        DNSServer(
            name: 'NextDNS DoH',
            description: 'NextDNS DoH endpoint, configurable via your profile ID.',
            protocol: DNSProtocol.doh,
            host: 'dns.nextdns.io',
            port: 443,
        ),
        DNSServer(
            name: 'Tor Exit DNS',
            description: 'DNS over Tor, experimental resolver for .onion compatibility.',
            protocol: DNSProtocol.udp,
            host: '10.40.40.40',
            port: 53,
        ),
        // TODO: TOR NS resolver
        // TODO: Root NS servers
    ];
}