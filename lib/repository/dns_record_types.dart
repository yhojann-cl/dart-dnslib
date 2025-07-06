import '../domain/dns_record_type.dart' show DNSRecordType;


class DNSRecordTypes {

    static const List<DNSRecordType> records = [

        // Common types
        DNSRecordType(name: 'A', id: 1, isCommon: true, isSpecial: false, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'AAAA', id: 28, isCommon: true, isSpecial: false, isObsolete: false, rfc: 3596),
        DNSRecordType(name: 'AFSDB', id: 18, isCommon: false, isSpecial: false, isObsolete: false, rfc: 1183),
        DNSRecordType(name: 'APL', id: 42, isCommon: false, isSpecial: false, isObsolete: false, rfc: 3123),
        DNSRecordType(name: 'CAA', id: 257, isCommon: false, isSpecial: false, isObsolete: false, rfc: 6844),
        DNSRecordType(name: 'CDNSKEY', id: 60, isCommon: false, isSpecial: false, isObsolete: false, rfc: 7344),
        DNSRecordType(name: 'CDS', id: 59, isCommon: false, isSpecial: false, isObsolete: false, rfc: 7344),
        DNSRecordType(name: 'CERT', id: 37, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4398),
        DNSRecordType(name: 'CNAME', id: 5, isCommon: true, isSpecial: false, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'CSYNC', id: 62, isCommon: false, isSpecial: false, isObsolete: false, rfc: 7477),
        DNSRecordType(name: 'DHCID', id: 49, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4701),
        DNSRecordType(name: 'DLV', id: 32769, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4431),
        DNSRecordType(name: 'DNAME', id: 39, isCommon: false, isSpecial: false, isObsolete: false, rfc: 6672),
        DNSRecordType(name: 'DNSKEY', id: 48, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4034),
        DNSRecordType(name: 'DS', id: 43, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4034),
        DNSRecordType(name: 'EUI48', id: 108, isCommon: false, isSpecial: false, isObsolete: false, rfc: 7043),
        DNSRecordType(name: 'EUI64', id: 109, isCommon: false, isSpecial: false, isObsolete: false, rfc: 7043),
        DNSRecordType(name: 'HINFO', id: 13, isCommon: false, isSpecial: false, isObsolete: false, rfc: 8482),
        DNSRecordType(name: 'HIP', id: 55, isCommon: false, isSpecial: false, isObsolete: false, rfc: 8005),
        DNSRecordType(name: 'HTTPS', id: 65, isCommon: false, isSpecial: false, isObsolete: false, rfc: 9460),
        DNSRecordType(name: 'IPSECKEY', id: 45, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4025),
        DNSRecordType(name: 'KEY', id: 25, isCommon: false, isSpecial: false, isObsolete: false, rfc: 2535),
        DNSRecordType(name: 'KX', id: 36, isCommon: false, isSpecial: false, isObsolete: false, rfc: 2230),
        DNSRecordType(name: 'LOC', id: 29, isCommon: false, isSpecial: false, isObsolete: false, rfc: 1876),
        DNSRecordType(name: 'MX', id: 15, isCommon: true, isSpecial: false, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'NAPTR', id: 35, isCommon: false, isSpecial: false, isObsolete: false, rfc: 3403),
        DNSRecordType(name: 'NS', id: 2, isCommon: true, isSpecial: false, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'NSEC', id: 47, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4034),
        DNSRecordType(name: 'NSEC3', id: 50, isCommon: false, isSpecial: false, isObsolete: false, rfc: 5155),
        DNSRecordType(name: 'NSEC3PARAM', id: 51, isCommon: false, isSpecial: false, isObsolete: false, rfc: 5155),
        DNSRecordType(name: 'OPENPGPKEY', id: 61, isCommon: false, isSpecial: false, isObsolete: false, rfc: 7929),
        DNSRecordType(name: 'PTR', id: 12, isCommon: false, isSpecial: false, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'RP', id: 17, isCommon: false, isSpecial: false, isObsolete: false, rfc: 1183),
        DNSRecordType(name: 'RRSIG', id: 46, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4034),
        DNSRecordType(name: 'SIG', id: 24, isCommon: false, isSpecial: false, isObsolete: false, rfc: 2535),
        DNSRecordType(name: 'SMIMEA', id: 53, isCommon: false, isSpecial: false, isObsolete: false, rfc: 8162),
        DNSRecordType(name: 'SOA', id: 6, isCommon: true, isSpecial: false, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'SRV', id: 33, isCommon: true, isSpecial: false, isObsolete: false, rfc: 2782),
        DNSRecordType(name: 'SSHFP', id: 44, isCommon: false, isSpecial: false, isObsolete: false, rfc: 4255),
        DNSRecordType(name: 'SVCB', id: 64, isCommon: false, isSpecial: false, isObsolete: false, rfc: 9460),
        DNSRecordType(name: 'TA', id: 32768, isCommon: false, isSpecial: false, isObsolete: false, rfc: null),
        DNSRecordType(name: 'TKEY', id: 249, isCommon: false, isSpecial: false, isObsolete: false, rfc: 2930),
        DNSRecordType(name: 'TLSA', id: 52, isCommon: false, isSpecial: false, isObsolete: false, rfc: 6698),
        DNSRecordType(name: 'TSIG', id: 250, isCommon: false, isSpecial: false, isObsolete: false, rfc: 2845),
        DNSRecordType(name: 'TXT', id: 16, isCommon: true, isSpecial: false, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'URI', id: 256, isCommon: false, isSpecial: false, isObsolete: false, rfc: 7553),
        DNSRecordType(name: 'ZONEMD', id: 63, isCommon: false, isSpecial: false, isObsolete: false, rfc: 8976),

        // Specials
        DNSRecordType(name: 'ANY', id: 255, isCommon: true, isSpecial: true, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'AXFR', id: 252, isCommon: true, isSpecial: true, isObsolete: false, rfc: 1035),
        DNSRecordType(name: 'IXFR', id: 251, isCommon: false, isSpecial: true, isObsolete: false, rfc: 1996),
        DNSRecordType(name: 'OPT', id: 41, isCommon: false, isSpecial: true, isObsolete: false, rfc: 6891),

        // Obsolete
        DNSRecordType(name: 'MD', id: 3, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'MF', id: 4, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'MAILA', id: 254, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'MB', id: 7, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'MG', id: 8, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'MR', id: 9, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'MINFO', id: 14, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'MAILB', id: 253, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'WKS', id: 11, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1035),
        DNSRecordType(name: 'NB', id: 32, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1002),
        DNSRecordType(name: 'NBSTAT', id: 33, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1002),
        DNSRecordType(name: 'NULL', id: 10, isCommon: false, isSpecial: false, isObsolete: true, rfc: 883),
        DNSRecordType(name: 'A6', id: 38, isCommon: false, isSpecial: false, isObsolete: true, rfc: 2874),
        DNSRecordType(name: 'NXT', id: 30, isCommon: false, isSpecial: false, isObsolete: true, rfc: 2065),
        DNSRecordType(name: 'X25', id: 19, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1183),
        DNSRecordType(name: 'ISDN', id: 20, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1183),
        DNSRecordType(name: 'RT', id: 21, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1183),
        DNSRecordType(name: 'NSAP', id: 22, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1706),
        DNSRecordType(name: 'NSAP-PTR', id: 23, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1706),
        DNSRecordType(name: 'PX', id: 26, isCommon: false, isSpecial: false, isObsolete: true, rfc: 2163),
        DNSRecordType(name: 'EID', id: 31, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'NIMLOC', id: 32, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'ATMA', id: 34, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'SINK', id: 40, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'GPOS', id: 27, isCommon: false, isSpecial: false, isObsolete: true, rfc: 1712),
        DNSRecordType(name: 'UINFO', id: 100, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'UID', id: 101, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'GID', id: 102, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'UNSPEC', id: 103, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'SPF', id: 99, isCommon: false, isSpecial: false, isObsolete: true, rfc: 4408),
        DNSRecordType(name: 'NINFO', id: 56, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'RKEY', id: 57, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'TALINK', id: 58, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
        DNSRecordType(name: 'NID', id: 104, isCommon: false, isSpecial: false, isObsolete: true, rfc: 6742),
        DNSRecordType(name: 'L32', id: 105, isCommon: false, isSpecial: false, isObsolete: true, rfc: 6742),
        DNSRecordType(name: 'L64', id: 106, isCommon: false, isSpecial: false, isObsolete: true, rfc: 6742),
        DNSRecordType(name: 'LP', id: 107, isCommon: false, isSpecial: false, isObsolete: true, rfc: 6742),
        DNSRecordType(name: 'DOA', id: 259, isCommon: false, isSpecial: false, isObsolete: true, rfc: null),
    ];

    static DNSRecordType findByName(String name) {
        return DNSRecordTypes.records
            .firstWhere((dnsRecordType) =>
                (dnsRecordType.name.toUpperCase() == name.toUpperCase().trim()));
    }

    static DNSRecordType findById(int id) {
        return DNSRecordTypes.records
            .firstWhere((dnsRecordType) =>
                (dnsRecordType.id == id));
    }
}