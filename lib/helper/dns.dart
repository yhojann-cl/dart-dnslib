import 'dart:typed_data';


class DNSHelper {

    static (int, String) parseDomainName(Uint8List data, int offset) {
        final List<String> parts = [ ];
        int originalOffset = offset;
        bool jumped = false;

        while (true) {
            final int length = data[offset];

            // Si es puntero
            if ((length & 0xC0) == 0xC0) {
                final int pointer = ((length & 0x3F) << 8) | data[offset + 1];
                if (!jumped) {
                    originalOffset = offset + 2; // Solo si no habíamos saltado antes
                }
      
                // Parse desde el puntero
                final (_, String name) = DNSHelper.parseDomainName(data, pointer);
                parts.add(name);
                break;
            }

            // Si es fin del nombre
            if (length == 0) {
                if (!jumped) {
                    originalOffset = offset + 1;
                }
                break;
            }

            // Nombre explícito
            offset += 1;
            parts.add(String.fromCharCodes(data.sublist(offset, offset + length)));
            offset += length;
        }

        return (originalOffset, parts.join('.'));
    }
}