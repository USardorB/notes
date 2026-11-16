import 'dart:math';
import 'dart:typed_data';

/// Generates RFC 9562 compliant **UUIDv7** identifiers.
///
/// Why UUIDv7 for Offline-First + SQLite:
/// - Globally unique across offline devices without server coordination.
/// - First 48 bits encode a Unix millisecond timestamp, making IDs naturally
///   time-ordered and B-tree index friendly in Drift/SQLite.
abstract final class UuidV7 {
  static final Random _random = Random.secure();

  static String generate() {
    final bytes = Uint8List(16);
    final timestampMs = DateTime.now().millisecondsSinceEpoch;

    // 48-bit big-endian Unix timestamp in milliseconds
    bytes[0] = (timestampMs >> 40) & 0xFF;
    bytes[1] = (timestampMs >> 32) & 0xFF;
    bytes[2] = (timestampMs >> 24) & 0xFF;
    bytes[3] = (timestampMs >> 16) & 0xFF;
    bytes[4] = (timestampMs >> 8) & 0xFF;
    bytes[5] = timestampMs & 0xFF;

    // Fill remaining 10 bytes with cryptographically secure random bits
    for (var i = 6; i < 16; i++) {
      bytes[i] = _random.nextInt(256);
    }

    // Set version to 7 (0111xxxx) in byte 6
    bytes[6] = (bytes[6] & 0x0F) | 0x70;

    // Set RFC 9562 variant to 10xxxxxx in byte 8
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    final hex = _toHex(bytes);
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20, 32)}';
  }

  static String _toHex(Uint8List bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
