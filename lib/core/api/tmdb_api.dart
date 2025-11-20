import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';
import '../models/actor.dart';

class TmdbApi {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  late final String _apiKey;

  TmdbApi() {
    _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  }

  /// Get popular actors
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

  /// Get movies for a specific actor
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

  /// Get cast for a specific movie
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

  /// Discover popular movies
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
