class StringUtils {
  /// Normalizes a string by removing accents, converting to lowercase, and trimming
  static String normalize(String input) {
    String result = input.toLowerCase().trim();

    // Remove accents
    const withAccents = 'àáâãäåèéêëìíîïòóôõöùúûüýÿñçÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÝŸÑÇ';
    const withoutAccents = 'aaaaaaeeeeiiiioooooouuuuyyncAAAAAEEEEIIIIOOOOOUUUUYYNC';

    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }

    return result;
  }

  /// Compares two strings with normalization
  static bool areEqual(String str1, String str2) {
    return normalize(str1) == normalize(str2);
  }
}
