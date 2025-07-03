# DNSLib

A DNS client library for Dart with full support for **UDP**, **TCP**, and
**DNS-over-HTTPS (DoH)** queries.

DNSLib enables direct DNS resolution from Dart applications without relying on
platform-native libraries or system commands. It’s ideal for CLI tools, Flutter
desktop apps, or network-sensitive environments where low-level DNS control is
required.


## Features

- Supports both IPv4 and IPv6.
- Works over **UDP**, **TCP**, and **DoH**.
- Fully asynchronous API.
- Minimal and dependency-free core.
- Built-in support for **AXFR** zone transfers.
- Compatible with **Dart CLI**, **Flutter Desktop**, and **Flutter Web** (DoH only).


### Supported DNS record types

`A`, `AAAA`, `AFSDB`, `APL`, `CAA`, `CDS`, `CERT`, `CNAME`, `DHCID`, `DLV`, `DNSKEY`, `EUI48`, `EUI64`, `HINFO`, `HIP`, `HTTPS`, `IPSECKEY`, `KEY`, `KX`, `LOC`, `MX`, `NAPTR`, `NS`, `NSEC`, `NSEC3PARAM`, `RP`, `SMIMEA`, `SOA`, `SRV`, `SSHFP`, `SVCB`, `TA`, `TXT`, `URI`.


## Installation

From the [pub.dev](https://pub.dev/packages/dnslib) repository using
command `dart pub add dnslib`.


## Short example

```dart
import 'package:dnslib/dnslib.dart';

// Create query
DNSClient // Returns a Future<List<DNSResponseRecord>>
    .query(
        domain: 'example.com',
        dnsRecordType: DNSRecordTypes.findByName('A'),
        dnsServer: DnsServer(host: '8.8.8.8'),
    )
    .then((records) {
        for (DNSResponseRecord record in records)
            print(record); // By default print in json format
    })
    .catchError((error) { // Catch any error here
        throw error;
    });
```

You can use a sync method:

```dart
final List<DNSResponseRecord> records = await DNSClient.query( // ...
```

You can see more examples in the [example](example/) directory.


## DnsServer

The definition object and properties are:

```dart
const DnsServer({
    required this.host,
    this.port = 53, // Default port
    this.protocol = DnsProtocol.udp, // Default protocol
    this.path = '/dns-query', // Default path for DoH
    this.headers = const { // Default headers for DoH
        'Accept': 'application/dns-message',
        'Content-Type': 'application/dns-message',
        'Connection': 'close',
    },
});
```

Protocols supported by `DnsProtocol` are `udp`, `tcp` and `doh`.


## DNSClient

The definition object and properties are:

```dart
class DNSClient {

    static Future<List<DNSResponseRecord>> query({
        required String domain,
        required DNSRecordType dnsRecordType,
        required DnsServer dnsServer,
        int timeout = 5000, // 5 seconds by default (in milliseconds)
    }) async { ...
```

## Notes & Considerations

- **DoH (DNS over HTTPS)** uses port `443` and HTTPS protocol. You must set `protocol: DnsProtocol.doh` and `port: 443` explicitly when using DoH.
- **AXFR** (zone transfer) is supported **only over TCP**. UDP and DoH do not support AXFR.
- All DNS queries use **OPT** records for extended responses and support for large payloads over TCP and UDP.


## Contributions

This project is open source and under active development. Contributions, bug
reports, and suggestions are welcome via [GitHub](https://github.com/yhojann-cl/dart-dnslib).
