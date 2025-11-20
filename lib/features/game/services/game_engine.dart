import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:string_similarity/string_similarity.dart';
import '../../../core/api/tmdb_api.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/actor.dart';
import '../../../core/utils/string_utils.dart';

enum GameState {
  loading,
  playing,
  correct,
  error,
}

class GameEngine extends ChangeNotifier {
  final TmdbApi _api = TmdbApi();
  final Random _random = Random();

  GameState _state = GameState.loading;
  int _score = 0;
  List<Movie> _currentMovies = [];
  List<Actor> _correctActors = [];
  String _errorMessage = '';
  String _userInput = '';
  String _lastCorrectActor = '';

  GameState get state => _state;
  int get score => _score;
  List<Movie> get currentMovies => _currentMovies;
  String get errorMessage => _errorMessage;
  String get userInput => _userInput;
  String get lastCorrectActor => _lastCorrectActor;

  GameEngine() {
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await generateNewRound();
  }

  /// Generate a new round with movies and actors
  Future<void> generateNewRound() async {
    _setState(GameState.loading);
    _errorMessage = '';

    try {
      // Try up to 5 times to generate a valid round
      for (int attempt = 0; attempt < 5; attempt++) {
        try {
          // Get popular actors
          final page = _random.nextInt(5) + 1;
          final actors = await _api.getPopularActors(page: page);

          if (actors.isEmpty) {
            throw Exception('No actors found');
          }

          // Pick a random actor
          final selectedActor = actors[_random.nextInt(actors.length)];

          // Get movies for this actor
          final movies = await _api.getMoviesForActor(selectedActor.id);

          if (movies.length < 2) {
            continue; // Try another actor
          }

          // Shuffle and select 2-5 movies
          movies.shuffle(_random);
          final movieCount = min(5, max(2, 2 + _random.nextInt(4)));
          final selectedMovies = movies.take(movieCount).toList();

          // Get cast for each movie and find common actors
          final List<Set<String>> movieCasts = [];

          for (final movie in selectedMovies) {
            final cast = await _api.getCastForMovie(movie.id);
            final actorNames = cast.map((actor) => StringUtils.normalize(actor.name)).toSet();
            movieCasts.add(actorNames);
          }

          // Find intersection of all casts
          if (movieCasts.isEmpty) {
            continue;
          }

          Set<String> commonActors = movieCasts[0];
          for (int i = 1; i < movieCasts.length; i++) {
            commonActors = commonActors.intersection(movieCasts[i]);
          }

          if (commonActors.isEmpty) {
            continue; // No common actors, try again
          }

          // Get full actor objects for common actors
          _correctActors = [];
          for (final movie in selectedMovies) {
            final cast = await _api.getCastForMovie(movie.id);
            for (final actor in cast) {
              final normalizedName = StringUtils.normalize(actor.name);
              if (commonActors.contains(normalizedName) &&
                  !_correctActors.any((a) => StringUtils.normalize(a.name) == normalizedName)) {
                _correctActors.add(actor);
              }
            }
          }

          // Success! We have a valid round
          _currentMovies = selectedMovies;
          _setState(GameState.playing);
          return;
        } catch (e) {
          debugPrint('Attempt $attempt failed: $e');
          continue;
        }
      }

      // All attempts failed
      throw Exception('Unable to generate a valid round after multiple attempts');
    } catch (e) {
      _errorMessage = 'Connection error. Please check your internet connection.';
      _setState(GameState.error);
      debugPrint('Error generating round: $e');
    }
  }

  /// Update user input
  void updateInput(String input) {
    _userInput = input;
    notifyListeners();
  }

  /// Check if the user's answer is correct
  Future<bool> checkAnswer(String answer) async {
    if (answer.trim().isEmpty) {
      return false;
    }

    final normalizedAnswer = StringUtils.normalize(answer);

    // Check exact match first
    for (final actor in _correctActors) {
      if (StringUtils.areEqual(actor.name, answer)) {
        await _handleCorrectAnswer(actor.name);
        return true;
      }
    }

    // Check fuzzy match (similarity > 0.85)
    for (final actor in _correctActors) {
      final similarity = normalizedAnswer.similarityTo(StringUtils.normalize(actor.name));
      if (similarity > 0.85) {
        await _handleCorrectAnswer(actor.name);
        return true;
      }
    }

    return false;
  }

  Future<void> _handleCorrectAnswer(String actorName) async {
    _score++;
    _lastCorrectActor = actorName;
    _userInput = '';
    _setState(GameState.correct);

    // Wait a bit to show success, then generate new round
    await Future.delayed(const Duration(milliseconds: 1500));
    await generateNewRound();
  }

  void _setState(GameState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Retry after an error
  Future<void> retry() async {
    await generateNewRound();
  }

  /// Skip current round (optional feature)
  Future<void> skipRound() async {
    await generateNewRound();
  }
}
