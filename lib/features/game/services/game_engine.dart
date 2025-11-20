import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:string_similarity/string_similarity.dart';
import '../../../core/api/tmdb_api.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/actor.dart';
import '../../../core/utils/string_utils.dart';

/// Represents the current state of the game.
///
/// - [loading]: A new round is being generated
/// - [playing]: The player is actively playing and can input an answer
/// - [correct]: The player has answered correctly (temporary state before loading next round)
/// - [error]: An error occurred (e.g., network error)
enum GameState {
  loading,
  playing,
  correct,
  error,
}

/// Core game logic and state management for the Movie Quiz game.
///
/// This class implements the entire game flow using the ChangeNotifier pattern
/// for reactive state management. It handles:
/// - Round generation (selecting movies and actors)
/// - Answer validation with fuzzy matching
/// - Score tracking
/// - Error handling and retry logic
///
/// The game follows this cycle:
/// 1. [loading] - Generate a new round
/// 2. [playing] - Display movies, wait for user input
/// 3. [correct] - Show success message (1.5s)
/// 4. Back to step 1 (infinite loop)
///
/// Example usage:
/// ```dart
/// final gameEngine = GameEngine();
///
/// // Listen to state changes
/// gameEngine.addListener(() {
///   print('Score: ${gameEngine.score}');
///   print('State: ${gameEngine.state}');
/// });
///
/// // Check an answer
/// await gameEngine.checkAnswer('Brad Pitt');
/// ```
class GameEngine extends ChangeNotifier {
  /// TMDB API service for fetching movie and actor data
  final TmdbApi _api = TmdbApi();

  /// Random number generator for selecting actors and movies
  final Random _random = Random();

  /// Current state of the game
  GameState _state = GameState.loading;

  /// Player's score (number of correct answers)
  int _score = 0;

  /// List of movies displayed in the current round
  List<Movie> _currentMovies = [];

  /// List of actors that are valid answers for the current round
  List<Actor> _correctActors = [];

  /// Error message to display (if state is [GameState.error])
  String _errorMessage = '';

  /// Current user input (not currently used but available for future features)
  String _userInput = '';

  /// Name of the last actor that was correctly guessed
  String _lastCorrectActor = '';

  /// Current game state
  GameState get state => _state;

  /// Player's current score
  int get score => _score;

  /// Movies displayed in the current round
  List<Movie> get currentMovies => _currentMovies;

  /// Error message (empty if no error)
  String get errorMessage => _errorMessage;

  /// Current user input
  String get userInput => _userInput;

  /// Name of the last correctly guessed actor
  String get lastCorrectActor => _lastCorrectActor;

  /// Creates a [GameEngine] instance and initializes the first game round.
  ///
  /// The constructor triggers [_initializeGame] which starts the first round
  /// generation asynchronously.
  GameEngine() {
    _initializeGame();
  }

  /// Initializes the game by generating the first round.
  ///
  /// This is called automatically by the constructor.
  Future<void> _initializeGame() async {
    await generateNewRound();
  }

  /// Generates a new game round with 2-5 movies that share at least one actor.
  ///
  /// This method performs the following steps:
  /// 1. Fetches popular actors from TMDB
  /// 2. Randomly selects one actor
  /// 3. Gets their filmography (filtered: after 1970, with poster)
  /// 4. Randomly selects 2-5 movies from their filmography
  /// 5. Fetches the cast for each movie
  /// 6. Finds the intersection of all casts (common actors)
  /// 7. Validates that at least one actor is common to all movies
  ///
  /// The method attempts up to 5 times to generate a valid round.
  /// If all attempts fail, it sets the state to [GameState.error].
  ///
  /// Round generation criteria:
  /// - Actor must have at least 2 valid movies
  /// - All selected movies must have a poster image
  /// - Movies must be released after 1970
  /// - At least one actor must appear in all selected movies
  ///
  /// Throws no exceptions (errors are handled internally and set error state).
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

  /// Updates the user input field.
  ///
  /// This method is available for future features that might need to track
  /// user input in real-time (e.g., autocomplete suggestions).
  ///
  /// Parameters:
  /// - [input]: The current text in the input field
  ///
  /// This method triggers [notifyListeners] to update the UI.
  void updateInput(String input) {
    _userInput = input;
    notifyListeners();
  }

  /// Checks if the user's answer matches any of the correct actors.
  ///
  /// This method uses two matching strategies:
  /// 1. **Exact match**: Case-insensitive and accent-insensitive comparison
  /// 2. **Fuzzy match**: String similarity > 85% (handles typos and variations)
  ///
  /// Matching is done using [StringUtils.normalize] to handle:
  /// - Case differences ('Brad Pitt' = 'brad pitt')
  /// - Accented characters ('José García' = 'jose garcia')
  /// - Leading/trailing spaces
  ///
  /// If a match is found:
  /// - Score is incremented
  /// - Success state is shown for 1.5 seconds
  /// - A new round is automatically generated
  ///
  /// Parameters:
  /// - [answer]: The user's guess (actor name)
  ///
  /// Returns:
  /// - `true` if the answer matches a correct actor
  /// - `false` otherwise
  ///
  /// Example:
  /// ```dart
  /// // All of these would match if 'Brad Pitt' is a correct answer:
  /// await checkAnswer('Brad Pitt');      // Exact match
  /// await checkAnswer('brad pitt');      // Case insensitive
  /// await checkAnswer('Brad  Pitt');     // Extra spaces
  /// await checkAnswer('Brad Pit');       // Fuzzy match (>85% similar)
  /// ```
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

  /// Handles the logic when a correct answer is provided.
  ///
  /// This internal method:
  /// 1. Increments the score
  /// 2. Stores the correct actor name for display
  /// 3. Clears the user input
  /// 4. Sets state to [GameState.correct]
  /// 5. Waits 1.5 seconds to show success message
  /// 6. Generates a new round
  ///
  /// Parameters:
  /// - [actorName]: The name of the actor that was correctly guessed
  Future<void> _handleCorrectAnswer(String actorName) async {
    _score++;
    _lastCorrectActor = actorName;
    _userInput = '';
    _setState(GameState.correct);

    // Wait a bit to show success, then generate new round
    await Future.delayed(const Duration(milliseconds: 1500));
    await generateNewRound();
  }

  /// Updates the game state and notifies listeners.
  ///
  /// This internal method is used to update [_state] and trigger UI updates
  /// through the ChangeNotifier pattern.
  ///
  /// Parameters:
  /// - [newState]: The new game state
  void _setState(GameState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Retries round generation after an error.
  ///
  /// This method is called when the user clicks a "Retry" button
  /// after encountering an error (e.g., network failure).
  ///
  /// It attempts to generate a new round, which may succeed if
  /// the error condition (e.g., network connectivity) has been resolved.
  Future<void> retry() async {
    await generateNewRound();
  }

  /// Skips the current round and generates a new one.
  ///
  /// This optional feature allows players to skip a round if they don't
  /// know the answer or find it too difficult. The score is not affected.
  ///
  /// Example usage:
  /// ```dart
  /// // Player clicks "Skip" button
  /// await gameEngine.skipRound();
  /// ```
  Future<void> skipRound() async {
    await generateNewRound();
  }
}
