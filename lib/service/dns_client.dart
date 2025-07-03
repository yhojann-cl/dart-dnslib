import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../helper/dns.dart' show DNSHelper;
import '../domain/dns_record_type.dart' show DNSRecordType;
import '../domain/dns_response_record.dart' show DNSResponseRecord;
import '../domain/dns_response_record_a.dart' show AResponseRecord;
import '../domain/dns_response_record_aaaa.dart' show AAAAResponseRecord;
import '../domain/dns_response_record_afsdb.dart' show AFSDBResponseRecord;
import '../domain/dns_response_record_apl.dart' show APLResponseRecord;
import '../domain/dns_response_record_caa.dart' show CAAResponseRecord;
import '../domain/dns_response_record_cds.dart' show CDSResponseRecord;
import '../domain/dns_response_record_cert.dart' show CERTResponseRecord;
import '../domain/dns_response_record_cname.dart' show CNAMEResponseRecord;
import '../domain/dns_response_record_dhcid.dart' show DHCIDResponseRecord;
import '../domain/dns_response_record_dlv.dart' show DLVResponseRecord;
import '../domain/dns_response_record_dnskey.dart' show DNSKEYResponseRecord;
import '../domain/dns_response_record_eui48.dart' show EUI48ResponseRecord;
import '../domain/dns_response_record_eui64.dart' show EUI64ResponseRecord;
import '../domain/dns_response_record_hinfo.dart' show HINFOResponseRecord;
import '../domain/dns_response_record_hip.dart' show HIPResponseRecord;
import '../domain/dns_response_record_https.dart' show HTTPSResponseRecord;
import '../domain/dns_response_record_ipseckey.dart' show IPSECKEYResponseRecord;
import '../domain/dns_response_record_key.dart' show KEYResponseRecord;
import '../domain/dns_response_record_kx.dart' show KXResponseRecord;
import '../domain/dns_response_record_loc.dart' show LOCResponseRecord;
import '../domain/dns_response_record_mx.dart' show MXResponseRecord;
import '../domain/dns_response_record_naptr.dart' show NAPTRResponseRecord;
import '../domain/dns_response_record_ns.dart' show NSResponseRecord;
import '../domain/dns_response_record_nsec.dart' show NSECResponseRecord;
import '../domain/dns_response_record_nsec3param.dart' show NSEC3PARAMResponseRecord;
import '../domain/dns_response_record_rp.dart' show RPResponseRecord;
import '../domain/dns_response_record_smimea.dart' show SMIMEAResponseRecord;
import '../domain/dns_response_record_soa.dart' show SOAResponseRecord;
import '../domain/dns_response_record_srv.dart' show SRVResponseRecord;
import '../domain/dns_response_record_sshfp.dart' show SSHFPResponseRecord;
import '../domain/dns_response_record_svcb.dart' show SVCBResponseRecord;
import '../domain/dns_response_record_ta.dart' show TAResponseRecord;
import '../domain/dns_response_record_txt.dart' show TXTResponseRecord;
import '../domain/dns_response_record_uri.dart' show URIResponseRecord;
import '../domain/dns_server.dart' show DnsServer;
import '../domain/dns_protocol.dart' show DnsProtocol;
import '../repository/dns_record_types.dart' show DNSRecordTypes;


/**
 *
 */
class DNSClient {

    static Future<List<DNSResponseRecord>> query({
        required String domain,
        required DNSRecordType dnsRecordType,
        required DnsServer dnsServer,
        int timeout = 5000, // 5 seconds by default (in milliseconds)
    }) async {
        
        final List<DNSResponseRecord> records = [ ];
        final Completer<List<DNSResponseRecord>> completer = Completer();

        if(dnsServer.protocol == DnsProtocol.udp) { // UDP connection

            // Construye el paquete de consulta DNS
            final Uint8List query = _buildQuery(domain, dnsRecordType);

            // Envia el paquete al servidor DNS vía UDP
            final RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
            socket.send(query, InternetAddress(dnsServer.host), dnsServer.port);

            // Timeout
            final timer = Timer(Duration(milliseconds: timeout), () {
                if (!completer.isCompleted) {
                    socket.close();
                    completer.completeError(TimeoutException('DNS query timeout'));
                }
            });

            // Event receiver
            socket.listen((RawSocketEvent event) {
                
                if (event == RawSocketEvent.read) {
                    final Datagram? response = socket.receive();

                    if (response != null) {
                        records.addAll(_parseResponse(response.data));
                        completer.complete(records);
                        socket.close(); // TODO: Multistream unsupported.
                        timer.cancel();
                    }

                // } else if (event == RawSocketEvent.write) {

                } else if(event == RawSocketEvent.closed) {
                    if(!completer.isCompleted)
                        completer.complete(records);
                    timer.cancel();
                }
            });

        } else if(dnsServer.protocol == DnsProtocol.tcp) { // TCP connection

            // Construye el paquete de consulta DNS
            final Uint8List query = _buildQuery(domain, dnsRecordType);

            // Connect to server using TCP
            final Socket socket = await Socket.connect(dnsServer.host, dnsServer.port);

            // DNS sobre TCP requiere una cabecera de 2 bytes con la longitud
            final Uint8List lengthPrefix = Uint8List(2);
            lengthPrefix[0] = (query.length >> 8) & 0xFF;
            lengthPrefix[1] = query.length & 0xFF;

            // Escribe la longitud y luego el query
            socket.add(lengthPrefix);
            socket.add(query);

            // Timeout
            final Timer timer = Timer(Duration(milliseconds: timeout), () {

                // Finalize thread with error
                if (!completer.isCompleted)
                    completer.completeError(TimeoutException('DNS TCP query timeout'));

                // Destroy socket connection
                socket.destroy();
            });

            // Stream parts
            int responseLength = 0;
            List<int> responseBuffer = [ ];
            
            // Bind socket events
            socket.listen(

                // On receive data event
                (List<int> bytes) {
                    
                    // First stream part
                    if(responseBuffer.length == 0) {

                        if (bytes.length < 2) {

                            // Cancel timeout
                            timer.cancel();

                            // Finalize thread with error
                            if (!completer.isCompleted)
                                completer.completeError(FormatException('TCP response too short'));

                            // Destroy socket connection
                            socket.destroy();

                            // Finalize function
                            return;
                        }

                        // Leer longitud de la respuesta
                        responseLength = (bytes[0] << 8) | bytes[1];
                        if (bytes.length - 2 < responseLength) {

                            // Cancel timeout
                            timer.cancel();

                            // Finalize thread with error
                            if (!completer.isCompleted)
                                completer.completeError(FormatException('Incomplete answer'));

                            // Destroy socket connection
                            socket.destroy();

                            // Finalize function
                            return;
                        }    
                    }

                    // Add stream part
                    responseBuffer.addAll(bytes);
                    
                    // End TCP parts
                    if(responseBuffer.length >= (responseLength + 2)) {

                        // Cancel timeout
                        timer.cancel();

                        // Transform response bytes
                        records.addAll(_parseResponse(Uint8List.fromList(responseBuffer.sublist(2, responseLength + 2))));

                        // Finalize thread with the results
                        if (!completer.isCompleted)
                            completer.complete(records);
                        
                        // Destroy socket connection
                        socket.destroy();
                    
                    } // else { await for other TCP parts ... }
                },
                onError: (error) {

                    // Cancel timeout
                    timer.cancel();

                    // Finalize thread with errors
                    if (!completer.isCompleted)
                        completer.completeError(error);
                },
                cancelOnError: true,
            );

        } else if(dnsServer.protocol == DnsProtocol.doh) { // DoH (HTTPS) connection

            // Create the http client
            final client = http.Client();

            // Create http POST request
            client.post(
                Uri.parse('https://${dnsServer.host}:${dnsServer.port}${dnsServer.path}'),
                headers: dnsServer.headers,
                body: _buildQuery(domain, dnsRecordType),
            )

            // Manual timeout
            .timeout(Duration(milliseconds: timeout))

            .then((http.Response response) {
                
                // Process response bytes
                records.addAll(_parseResponse(response.bodyBytes));

                // Finalize thread with the results
                if (!completer.isCompleted)
                    completer.complete(records);

                // End http connection
                client.close();
            })

            .catchError((error) {
                // Finalize thread with errors
                if (!completer.isCompleted)
                    completer.completeError(error);
            });
        }

        return completer.future;
    }

    static Uint8List _buildQuery(String domain, DNSRecordType dnsRecordType) {
        final BytesBuilder bytesBuilder = BytesBuilder();

        // Header: 12 bytes (con ARCOUNT = 1 para incluir OPT record)
        bytesBuilder.add([
            0x12, 0x34,   // ID
            0x01, 0x00,   // Flags
            0x00, 0x01,   // QDCOUNT (1 pregunta)
            0x00, 0x00,   // ANCOUNT
            0x00, 0x00,   // NSCOUNT
            0x00, 0x01,   // ARCOUNT (1 adicional = OPT)
        ]);

        // Pregunta (QNAME)
        for (final part in domain.split('.')) {
            bytesBuilder.add([part.length]);
            bytesBuilder.add(part.codeUnits);
        }
        bytesBuilder.add([0x00]); // Terminador QNAME

        // QTYPE y QCLASS
        bytesBuilder.add([
            (dnsRecordType.id >> 8) & 0xFF,
            dnsRecordType.id & 0xFF,   // QTYPE
            0x00, 0x01,                // QCLASS = IN
        ]);

        // Registro adicional: OPT (EDNS)
        bytesBuilder.add([
            0x00,         // root name
            0x00, 0x29,   // TYPE = OPT (41)
            0x04, 0xD0,   // UDP payload size = 1232
            0x00,         // extended RCODE
            0x00,         // EDNS version
            0x00, 0x00,   // Z flags
            0x00, 0x00    // data length = 0
        ]);

        return bytesBuilder.toBytes();
    }

    static List<DNSResponseRecord> _parseResponse(Uint8List bytes) {
        
        // DNS responses
        final List<DNSResponseRecord> records = [ ];

        // Header DNS response
        final int headerId = (bytes[0] << 8) | bytes[0 + 1]; // ID (uint16)
        final int headerFlags = (bytes[2] << 8) | bytes[2 + 1]; // Flags (uint16)
        final int headerFlagQR = (headerFlags >> 15) & 0x1; // 1 bit (QR: Question or answer)
        final int headerFlagOpcode = (headerFlags >> 11) & 0xF; // 4 bits (Opcode)
        final int headerFlagAuthoritiveAnswer = (headerFlags >> 10) & 0x1; // 1 bit (Authoritative Answer)
        final int headerFlagTruncated = (headerFlags >> 9) & 0x1; // 1 bit (Truncated)
        final int headerFlagRecursionDesired = (headerFlags >> 8) & 0x1; // 1 bit (Recursion Desired)
        final int headerFlagRecursionAvailable = (headerFlags >> 7) & 0x1; // 1 bit (Recursion Available)
        final int headerFlagZ = (headerFlags >> 4) & 0x7; // 3 bits (Reserved)
        final int headerFlagResponseCode = headerFlags & 0xF; // 4 bits (Response code)
        final int headerQDCount = (bytes[4] << 8) | bytes[4 + 1]; // Questions count (uint16)
        final int headerANCount = (bytes[6] << 8) | bytes[6 + 1]; // Response count (uint16)
        final int headerNSCount = (bytes[8] << 8) | bytes[8 + 1]; // Authority records count (uint16)
        final int headerARCount = (bytes[10] << 8) | bytes[10 + 1]; // Additional records count (uint16)
        
        // Current byte offset
        int offset = 12;

        // Body DNS response: The query.

        // Extract n questions
        for(int questionNumber = 0; questionNumber < headerQDCount; questionNumber++) {

            // Question hostname
            final String bodyQueryName;
            (offset, bodyQueryName) = DNSHelper.parseDomainName(bytes, offset);

            // Question query type (uint16)
            final int bodyQueryType = (bytes[offset] << 8) | bytes[offset + 1];
            offset += 2;

            // Question query class type (uint16)
            final int bodyQueryClass = (bytes[offset] << 8) | bytes[offset + 1];
            offset += 2;
        }

        // Have answers?
        if(headerANCount > 0) {

            // Process answers
            for (int i = 0; i < headerANCount; i++) {

                final String answerName;
                (offset, answerName) = DNSHelper.parseDomainName(bytes, offset);

                // Read record type id (uint16)
                final int answerRecordType = (bytes[offset] << 8) | bytes[offset + 1];
                offset += 2;

                // Read CLASS (uint16)
                final int answerClassType = (bytes[offset] << 8) | bytes[offset + 1];
                offset += 2;

                // Read TTL (uint32)
                final int answerTTL = (bytes[offset] << 24) |
                    (bytes[offset + 1] << 16) |
                    (bytes[offset + 2] << 8) |
                    bytes[offset + 3];
                offset += 4;

                // Read RDLENGTH (uint16)
                final int answerRecordDataLength = (bytes[offset] << 8) | bytes[offset + 1];
                offset += 2;

                if (answerRecordType == DNSRecordTypes.findByName('A').id) {
                    records.add(AResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('AAAA').id) {
                    records.add(AAAAResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));
                
                } else if (answerRecordType == DNSRecordTypes.findByName('AFSDB').id) {
                    records.add(AFSDBResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('APL').id) {
                    records.add(APLResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('CAA').id) {
                    records.add(CAAResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('CDNSKEY').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('CDS').id) {
                    records.add(CDSResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('CERT').id) {
                    records.add(CERTResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('CNAME').id) {
                    records.add(CNAMEResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('CSYNC').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('DHCID').id) {
                    records.add(DHCIDResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('DLV').id) {
                    records.add(DLVResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('DNAME').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('DNSKEY').id) {
                    records.add(DNSKEYResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('DS').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('EUI48').id) {
                    records.add(EUI48ResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('EUI64').id) {
                    records.add(EUI64ResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('HINFO').id) {
                    records.add(HINFOResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('HIP').id) {
                    records.add(HIPResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('HTTPS').id) {
                    records.add(HTTPSResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('IPSECKEY').id) {
                    records.add(IPSECKEYResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('KEY').id) {
                    records.add(KEYResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('KX').id) {
                    records.add(KXResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('LOC').id) {
                    records.add(LOCResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('MX').id) {
                    records.add(MXResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('NAPTR').id) {
                    records.add(NAPTRResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('NS').id) {
                    records.add(NSResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('NSEC').id) {
                    records.add(NSECResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('NSEC3').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('NSEC3PARAM').id) {
                    records.add(NSEC3PARAMResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('OPENPGPKEY').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('PTR').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('RP').id) {
                    records.add(RPResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('RRSIG').id) {
                    // TODO: Unimplemented.
                
                } else if (answerRecordType == DNSRecordTypes.findByName('SIG').id) {
                    // TODO: Unimplemented.
                
                } else if (answerRecordType == DNSRecordTypes.findByName('SMIMEA').id) {
                    records.add(SMIMEAResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('SOA').id) {
                    records.add(SOAResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('SRV').id) {
                    records.add(SRVResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('SSHFP').id) {
                    records.add(SSHFPResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('SVCB').id) {
                    records.add(SVCBResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('TA').id) {
                    records.add(TAResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('TKEY').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('TLSA').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('TSIG').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('TXT').id) {
                    records.add(TXTResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('URI').id) {
                    records.add(URIResponseRecord.fromBytes(
                        name: answerName,
                        ttl: answerTTL,
                        bytes: bytes,
                        offset: offset,
                        length: answerRecordDataLength));

                } else if (answerRecordType == DNSRecordTypes.findByName('ZONEMD').id) {
                    // TODO: Unimplemented.

                } else if (answerRecordType == DNSRecordTypes.findByName('MD').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('MF').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('MAILA').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('MB').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('MG').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('MR').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('MINFO').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('MAILB').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('WKS').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NB').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NBSTAT').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NULL').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('A6').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NXT').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('X25').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('ISDN').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('RT').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NSAP').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NSAPPTR').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('PX').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('EID').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NIMLOC').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('ATMA').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('SINK').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('GPOS').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('UINFO').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('UID').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('GID').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('UNSPEC').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('SPF').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NINFO').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('RKEY').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('TALINK').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('NID').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('L32').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('L64').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('LP').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('DOA').id) { // Obsolete

                } else if (answerRecordType == DNSRecordTypes.findByName('OPT').id) { // Special

                } else {
                    throw FormatException('Unknown response record type for "${answerRecordType}".');
                }

                // Move the pointer
                offset += answerRecordDataLength;
            }
        }

        return records;
    }
}