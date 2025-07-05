import 'dart:typed_data' show Uint8List;
import 'dart:convert' show jsonEncode;
import './dns_response_record.dart' show DNSResponseRecord;


/**
 *
 */
class LOCResponseRecord extends DNSResponseRecord {
  
    final int version;
    final int size;
    final int horizontalPrecision;
    final int verticalPrecision;
    final double latitude;  // grados decimales
    final double longitude; // grados decimales
    final double altitude;  // metros

    LOCResponseRecord({
        required String name,
        required int ttl,
        required this.version,
        required this.size,
        required this.horizontalPrecision,
        required this.verticalPrecision,
        required this.latitude,
        required this.longitude,
        required this.altitude,
    }) : super(name: name, ttl: ttl);

    static LOCResponseRecord fromBytes({
        required String name,
        required int ttl,
        required Uint8List bytes,
        required int offset,
        required int length }) {
        
        if (length < 16 || (offset + 16) > bytes.length)
            throw FormatException('Invalid LOC record: length too short');

        final int version = bytes[offset];
        final int size = bytes[offset + 1];
        final int hPrecision = bytes[offset + 2];
        final int vPrecision = bytes[offset + 3];

        int readUint32(int pos) => (bytes[pos] << 24) |
            (bytes[pos + 1] << 16) |
            (bytes[pos + 2] << 8) |
            bytes[pos + 3];

        final int rawLat = readUint32(offset + 4);
        final int rawLon = readUint32(offset + 8);
        final int rawAlt = readUint32(offset + 12);

        // Convertir a grados decimales
        double convertCoord(int rawCoord) {
            // rawCoord = milésimas de segundos + 2^31
            return ((rawCoord - 0x80000000) / 1000.0) / 3600.0;
        }

        // Altitud en metros = (rawAlt - 100000*1000)/1000.0
        double altitude = (rawAlt - 100000000) / 1000.0;

        return LOCResponseRecord(
        name: name,
        ttl: ttl,
        version: version,
        size: size,
        horizontalPrecision: hPrecision,
        verticalPrecision: vPrecision,
        latitude: convertCoord(rawLat),
        longitude: convertCoord(rawLon),
        altitude: altitude);
    }

    @override
    String get type => 'LOC';

    @override
    Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'ttl': ttl,
        'latitude': latitude, // °
        'longitude': longitude, // °
        'altitude': altitude, // m
    };
    
    @override
    String toString() => jsonEncode(toJson());

    // 37 47 0.000 N 122 24 0.000 W 10.00m 1m 10000m 10m
    // { name:example.com, ttl:86400, latitude:37.78333333333333°, longitude:-122.4°, altitude:-89999.0m }
}
