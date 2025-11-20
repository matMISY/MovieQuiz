import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';
import '../models/actor.dart';

/// Service class for interacting with The Movie Database (TMDB) API.
///
/// This class provides methods to fetch movie and actor data from TMDB.
/// It requires a valid API key to be set in the `.env` file.
///
/// Configuration:
/// ```
/// TMDB_API_KEY=your_api_key_here
/// ```
///
/// API Documentation: https://developers.themoviedb.org/3
///
/// Example usage:
/// ```dart
/// final api = TmdbApi();
/// final actors = await api.getPopularActors(page: 1);
/// final movies = await api.getMoviesForActor(287); // Brad Pitt's movies
/// ```
class TmdbApi {
  /// Base URL for all TMDB API v3 requests
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  /// API key loaded from environment variables
  late final String _apiKey;

  /// Creates a [TmdbApi] instance and loads the API key from environment.
  ///
  /// The API key is read from the `TMDB_API_KEY` environment variable.
  /// If not found, an empty string is used (which will cause API calls to fail).
  TmdbApi() {
    _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  }

  /// Fetches a list of popular actors from TMDB.
  ///
  /// This endpoint returns actors sorted by popularity, which is useful
  /// for selecting well-known actors for the game.
  ///
  /// API Endpoint: `GET /person/popular`
  ///
  /// Parameters:
  /// - [page]: The page number to fetch (1-based, default: 1)
  ///
  /// Returns: A list of [Actor] objects
  ///
  /// Throws:
  /// - [Exception] if the API request fails or returns an error status
  ///
  /// Example:
  /// ```dart
  /// final actors = await api.getPopularActors(page: 1);
  /// print('Found ${actors.length} popular actors');
  /// ```
  Future<List<Actor>> getPopularActors({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/person/popular?api_key=$_apiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((json) => Actor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load popular actors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching popular actors: $e');
    }
  }

  /// Fetches all movies in which a specific actor has appeared.
  ///
  /// This method retrieves the filmography of an actor and applies filters:
  /// - Movies must have a poster image available
  /// - Movies must be released after 1970
  ///
  /// These filters ensure we only use movies suitable for the game.
  ///
  /// API Endpoint: `GET /person/{person_id}/movie_credits`
  ///
  /// Parameters:
  /// - [actorId]: The TMDB ID of the actor
  ///
  /// Returns: A list of [Movie] objects that meet the filter criteria
  ///
  /// Throws:
  /// - [Exception] if the API request fails or returns an error status
  ///
  /// Example:
  /// ```dart
  /// // Get Brad Pitt's movies (ID: 287)
  /// final movies = await api.getMoviesForActor(287);
  /// print('Brad Pitt appeared in ${movies.length} valid movies');
  /// ```
  Future<List<Movie>> getMoviesForActor(int actorId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/person/$actorId/movie_credits?api_key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cast = data['cast'] as List;

        // Filter movies: must have poster, released after 1970
        return cast
            .map((json) => Movie.fromJson(json))
            .where((movie) {
              final releaseDate = json.decode(response.body)['cast']
                  .firstWhere((m) => m['id'] == movie.id, orElse: () => {})['release_date'] as String?;

              final hasValidPoster = movie.posterPath != null && movie.posterPath!.isNotEmpty;
              final isAfter1970 = releaseDate != null &&
                  releaseDate.isNotEmpty &&
                  int.tryParse(releaseDate.substring(0, 4)) != null &&
                  int.parse(releaseDate.substring(0, 4)) >= 1970;

              return hasValidPoster && isAfter1970;
            })
            .toList();
      } else {
        throw Exception('Failed to load movies for actor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies for actor: $e');
    }
  }

  /// Fetches the full cast list for a specific movie.
  ///
  /// This method is used to find common actors between multiple movies
  /// in the game. It returns all actors who appeared in the specified movie.
  ///
  /// API Endpoint: `GET /movie/{movie_id}/credits`
  ///
  /// Parameters:
  /// - [movieId]: The TMDB ID of the movie
  ///
  /// Returns: A list of [Actor] objects representing the movie's cast
  ///
  /// Throws:
  /// - [Exception] if the API request fails or returns an error status
  ///
  /// Example:
  /// ```dart
  /// // Get cast for Fight Club (ID: 550)
  /// final cast = await api.getCastForMovie(550);
  /// print('Fight Club has ${cast.length} cast members');
  /// ```
  Future<List<Actor>> getCastForMovie(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cast = data['cast'] as List;
        return cast.map((json) => Actor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cast for movie: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cast for movie: $e');
    }
  }

  /// Discovers popular movies from TMDB.
  ///
  /// This method fetches movies sorted by popularity and filters them
  /// to only include movies with valid poster images released after 1970.
  ///
  /// This is currently not used in the main game flow but can be useful
  /// for future features or alternative game modes.
  ///
  /// API Endpoint: `GET /discover/movie`
  ///
  /// Parameters:
  /// - [page]: The page number to fetch (1-based, default: 1)
  ///
  /// Returns: A list of [Movie] objects that meet the filter criteria
  ///
  /// Throws:
  /// - [Exception] if the API request fails or returns an error status
  ///
  /// Example:
  /// ```dart
  /// final movies = await api.discoverPopularMovies(page: 1);
  /// print('Found ${movies.length} popular movies');
  /// ```
  Future<List<Movie>> discoverPopularMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/discover/movie?api_key=$_apiKey&page=$page&sort_by=popularity.desc&primary_release_date.gte=1970-01-01',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results
            .map((json) => Movie.fromJson(json))
            .where((movie) => movie.posterPath != null && movie.posterPath!.isNotEmpty)
            .toList();
      } else {
        throw Exception('Failed to discover movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error discovering movies: $e');
    }
  }
}
