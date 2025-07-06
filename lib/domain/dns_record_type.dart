import 'dart:convert' show jsonEncode;


class DNSRecordType {

    final String name;
    final int id;
    final bool isCommon;
    final bool isSpecial;
    final bool isObsolete;
    final int? rfc;

    const DNSRecordType({
        this.rfc,
        required this.name,
        required this.id,
        required this.isCommon,
        required this.isSpecial,
        required this.isObsolete,
    });

    Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'isCommon': isCommon,
        'isSpecial': isSpecial,
        'isObsolete': isObsolete,
        'rfc': rfc,
    };
    
    @override
    String toString() => jsonEncode(toJson());
}