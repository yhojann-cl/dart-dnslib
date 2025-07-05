import '../domain/dns_server.dart' show DnsServer;
import '../domain/dns_protocol.dart' show DnsProtocol;


class DnsServers {

    static List<DnsServer> servers = [
        DnsServer(
            name: 'Google NS1',
            description: 'Public primary Name Server of Google without filters but with access speed restrictions.',
            protocol: DnsProtocol.udp,
            host: '8.8.8.8',
            port: 53,
        ),
        DnsServer(
            name: 'Google NS2',
            description: 'Public secondary Name Server of Google without filters but with access speed restrictions.',
            protocol: DnsProtocol.udp,
            host: '8.8.4.4',
            port: 53,
        ),
        DnsServer(
            name: 'Google DoH',
            description: 'Public DNS over HTTPS (DoH) server of Google.',
            protocol: DnsProtocol.doh,
            host: 'dns.google',
            port: 443,
        ),
        DnsServer(
            name: 'Cloudflare NS1',
            description: 'Public primary Name Server of Cloudflare without filters.',
            protocol: DnsProtocol.udp,
            host: '1.1.1.1',
            port: 53,
        ),
        DnsServer(
            name: 'Cloudflare NS2',
            description: 'Public secondary Name Server of Cloudflare without filters.',
            protocol: DnsProtocol.udp,
            host: '1.0.0.1',
            port: 53,
        ),
        DnsServer(
            name: 'Cloudflare DoH',
            description: 'Cloudflare DNS over HTTPS endpoint.',
            protocol: DnsProtocol.doh,
            host: 'cloudflare-dns.com',
            port: 443,
        ),
        DnsServer(
            name: 'Comodo NS1',
            description: 'Public primary Name Server of Comodo without filters. Use is limited to 300.000 monthly resolutions.',
            protocol: DnsProtocol.udp,
            host: '8.26.56.26',
            port: 53,
        ),
        DnsServer(
            name: 'Comodo NS2',
            description: 'Public secondary Name Server of Comodo without filters. Use is limited to 300.000 monthly resolutions.',
            protocol: DnsProtocol.udp,
            host: '8.20.247.20',
            port: 53,
        ),
        DnsServer(
            name: 'Verisign NS1',
            protocol: DnsProtocol.udp,
            host: '64.6.64.6',
            port: 53,
            description: 'Public primary Name Server of Verisign.'
        ),
        DnsServer(
            name: 'Verisign NS2',
            description: 'Public secondary Name Server of Verisign.',
            protocol: DnsProtocol.udp,
            host: '64.6.65.6',
            port: 53,
        ),
        DnsServer(
            name: 'DNS.Watch NS1',
            description: 'Public primary Name Server of DNS.Watch.',
            protocol: DnsProtocol.udp,
            host: '84.200.69.80',
            port: 53,
        ),
        DnsServer(
            name: 'DNS.Watch NS2',
            description: 'Public secondary Name Server of DNS.Watch.',
            protocol: DnsProtocol.udp,
            host: '84.200.70.40',
            port: 53,
        ),
        DnsServer(
            name: 'OpenDNS NS1',
            description: 'Public primary Name Server of OpenDNS with filters.',
            protocol: DnsProtocol.udp,
            host: '208.67.222.222',
            port: 53,
        ),
        DnsServer(
            name: 'OpenDNS NS2',
            description: 'Public secondary Name Server of OpenDNS with filters.',
            protocol: DnsProtocol.udp,
            host: '208.67.220.220',
            port: 53,
        ),
        DnsServer(
            name: 'Oracle Dyn NS1',
            description: 'Public primary Name Server of Oracle Dyn without filters.',
            protocol: DnsProtocol.udp,
            host: '216.146.35.35',
            port: 53,
        ),
        DnsServer(
            name: 'Oracle Dyn NS2',
            description: 'Public secondary Name Server of Oracle Dyn without filters.',
            protocol: DnsProtocol.udp,
            host: '216.146.36.36',
            port: 53,
        ),
        DnsServer(
            name: 'IBM Quad9 NS1',
            description: 'Public secondary Name Server of IBM Quad9.',
            protocol: DnsProtocol.udp,
            host: '9.9.9.9',
            port: 53,
        ),
        DnsServer(
            name: 'IBM Quad9 DoH',
            description: 'Quad9 DNS over HTTPS endpoint with malware blocking.',
            protocol: DnsProtocol.doh,
            host: 'dns.quad9.net',
            port: 443,
        ),
        DnsServer(
            name: 'Level 3 (Centrulink) NS1',
            description: 'Public primary Name Server of Centrulink (Underwater internet cable provider).',
            protocol: DnsProtocol.udp,
            host: '4.2.2.2',
            port: 53,
        ),
        DnsServer(
            name: 'Level 3 (Centrulink) NS2',
            description: 'Public secondary Name Server of Centrulink (Underwater internet cable provider).',
            protocol: DnsProtocol.udp,
            host: '4.2.2.3',
            port: 53,
        ),
        DnsServer(
            name: 'Level 3 (Centrulink) NS3',
            description: 'Public third Name Server of Centrulink (Underwater internet cable provider).',
            protocol: DnsProtocol.udp,
            host: '4.2.2.4',
            port: 53,
        ),
        DnsServer(
            name: 'Digitalcourage NS1',
            description: 'DNS server from Digitalcourage with no logging.',
            protocol: DnsProtocol.udp,
            host: '46.182.19.48',
            port: 53,
        ),
        DnsServer(
            name: 'NextDNS DoH',
            description: 'NextDNS DoH endpoint, configurable via your profile ID.',
            protocol: DnsProtocol.doh,
            host: 'dns.nextdns.io',
            port: 443,
        ),
        DnsServer(
            name: 'Tor Exit DNS',
            description: 'DNS over Tor, experimental resolver for .onion compatibility.',
            protocol: DnsProtocol.udp,
            host: '10.40.40.40',
            port: 53,
        ),
        // TODO: TOR NS resolver
        // TODO: Root NS servers
    ];
}