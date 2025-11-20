/// Represents a movie from The Movie Database (TMDB).
///
/// This model contains the essential information needed to display
/// a movie in the game, including its ID, title, and poster image.
///
/// Example usage:
/// ```dart
/// final movie = Movie(
///   id: 550,
///   title: 'Fight Club',
///   posterPath: '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg',
/// );
/// print(movie.getPosterUrl()); // Full TMDB poster URL
/// ```
class Movie {
  /// The unique TMDB movie ID.
  final int id;

  /// The movie title.
  final String title;

  /// The relative path to the movie poster on TMDB.
  ///
  /// This will be null if no poster is available.
  /// Use [getPosterUrl] to get the full URL.
  final String? posterPath;

  /// Creates a [Movie] instance.
  ///
  /// The [id] and [title] are required, while [posterPath] is optional.
  Movie({
    required this.id,
    required this.title,
    this.posterPath,
  });

  /// Creates a [Movie] from a JSON object returned by the TMDB API.
  ///
  /// Expected JSON format:
  /// ```json
  /// {
  ///   "id": 550,
  ///   "title": "Fight Club",
  ///   "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"
  /// }
  /// ```
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
    );
  }

  /// Converts this [Movie] to a JSON object.
  ///
  /// Returns a map that can be serialized to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
    };
  }

  /// Returns the full URL to the movie poster image.
  ///
  /// The poster is fetched from TMDB's CDN at w500 resolution.
  /// Returns an empty string if no poster path is available.
  ///
  /// Example return value:
  /// `https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg`
  String getPosterUrl() {
    if (posterPath == null) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}
