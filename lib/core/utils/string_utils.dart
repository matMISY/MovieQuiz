/// Utility class for string manipulation operations.
///
/// Provides methods for normalizing strings, particularly useful for
/// comparing user input with actor names while being tolerant of
/// case differences and accented characters.
///
/// Example:
/// ```dart
/// StringUtils.normalize('José García'); // returns 'jose garcia'
/// StringUtils.areEqual('José', 'jose');  // returns true
/// ```
class StringUtils {
  /// Normalizes a string by removing accents, converting to lowercase, and trimming.
  ///
  /// This method performs three operations:
  /// 1. Converts the string to lowercase
  /// 2. Trims leading and trailing whitespace
  /// 3. Removes accented characters, replacing them with their base equivalents
  ///
  /// Supported accent removal:
  /// - French accents: é, è, ê, ë, à, â, etc.
  /// - Spanish accents: á, í, ó, ú, ñ, etc.
  /// - German umlauts: ä, ö, ü
  /// - And more...
  ///
  /// Example:
  /// ```dart
  /// StringUtils.normalize('José García')  // returns 'jose garcia'
  /// StringUtils.normalize('Björk')        // returns 'bjork'
  /// StringUtils.normalize('  Zoë  ')      // returns 'zoe'
  /// ```
  ///
  /// Parameters:
  /// - [input]: The string to normalize
  ///
  /// Returns: The normalized string
  static String normalize(String input) {
    String result = input.toLowerCase().trim();

    // Remove accents by replacing accented characters with their base equivalents
    const withAccents = 'àáâãäåèéêëìíîïòóôõöùúûüýÿñçÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÝŸÑÇ';
    const withoutAccents = 'aaaaaaeeeeiiiioooooouuuuyyncAAAAAEEEEIIIIOOOOOUUUUYYNC';

    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }

    return result;
  }

  /// Compares two strings for equality after normalization.
  ///
  /// Both strings are normalized using [normalize] before comparison,
  /// making the comparison case-insensitive and accent-insensitive.
  ///
  /// This is particularly useful for comparing user input with actor names
  /// in the game, allowing variations like:
  /// - 'Brad Pitt' == 'brad pitt'
  /// - 'José García' == 'jose garcia'
  /// - '  Tom Hanks  ' == 'Tom Hanks'
  ///
  /// Example:
  /// ```dart
  /// StringUtils.areEqual('José', 'jose');           // true
  /// StringUtils.areEqual('Brad Pitt', 'BRAD PITT'); // true
  /// StringUtils.areEqual('Tom Hanks', 'Tim Hanks'); // false
  /// ```
  ///
  /// Parameters:
  /// - [str1]: First string to compare
  /// - [str2]: Second string to compare
  ///
  /// Returns: `true` if the normalized strings are equal, `false` otherwise
  static bool areEqual(String str1, String str2) {
    return normalize(str1) == normalize(str2);
  }
}
