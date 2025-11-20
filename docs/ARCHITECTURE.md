# Architecture Documentation

## Table of Contents
- [Overview](#overview)
- [Project Structure](#project-structure)
- [Architectural Patterns](#architectural-patterns)
- [Data Flow](#data-flow)
- [Core Components](#core-components)
- [State Management](#state-management)
- [API Integration](#api-integration)
- [UI Layer](#ui-layer)

## Overview

Movie Quiz is a Flutter application that follows a **clean architecture** approach with clear separation of concerns. The app is structured into layers:

1. **Core Layer**: Shared utilities, models, and API services
2. **Feature Layer**: Game-specific logic and UI
3. **Presentation Layer**: Widgets and screens

### Key Architectural Principles

- **Separation of Concerns**: Business logic, data, and UI are separated
- **Single Responsibility**: Each class has one clear purpose
- **Dependency Injection**: Dependencies are injected where needed
- **Reactive Programming**: UI reacts to state changes via Provider

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── core/                          # Shared/reusable code
│   ├── api/
│   │   └── tmdb_api.dart         # TMDB API client
│   ├── models/
│   │   ├── movie.dart            # Movie data model
│   │   └── actor.dart            # Actor data model
│   └── utils/
│       └── string_utils.dart     # String utilities (normalization)
└── features/                      # Feature modules
    └── game/                      # Game feature
        ├── pages/
        │   └── game_page.dart    # Main game screen
        ├── widgets/
        │   └── movie_posters.dart # Movie poster grid
        └── services/
            └── game_engine.dart   # Game logic & state
```

### Folder Responsibilities

| Folder | Responsibility |
|--------|---------------|
| `core/api` | External API communication |
| `core/models` | Data structures and serialization |
| `core/utils` | Helper functions and utilities |
| `features/game/pages` | Full-screen UI components |
| `features/game/widgets` | Reusable UI components |
| `features/game/services` | Business logic and state management |

## Architectural Patterns

### 1. Clean Architecture

The app follows clean architecture principles:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│   (UI: Pages, Widgets)              │
└───────────────┬─────────────────────┘
                │
┌───────────────▼─────────────────────┐
│         Business Logic Layer        │
│   (Services: GameEngine)            │
└───────────────┬─────────────────────┘
                │
┌───────────────▼─────────────────────┐
│          Data Layer                 │
│   (API: TmdbApi, Models)            │
└─────────────────────────────────────┘
```

### 2. Provider Pattern (State Management)

We use the **Provider** package for reactive state management:

- `GameEngine` extends `ChangeNotifier`
- UI widgets listen to `GameEngine` changes
- When state changes, `notifyListeners()` triggers UI rebuild

### 3. Repository Pattern

The `TmdbApi` class acts as a repository:
- Abstracts API calls from business logic
- Handles HTTP requests and error handling
- Transforms raw JSON into typed models

## Data Flow

### Game Round Generation Flow

```
┌──────────────┐
│ GameEngine   │
│ Constructor  │
└──────┬───────┘
       │
       ▼
┌──────────────────────────────────────┐
│ generateNewRound()                   │
│                                      │
│ 1. Fetch popular actors (TmdbApi)   │
│ 2. Select random actor               │
│ 3. Get actor's movies (TmdbApi)     │
│ 4. Select 2-5 random movies          │
│ 5. Get cast for each movie (TmdbApi)│
│ 6. Find common actors (intersection) │
│ 7. Update state to PLAYING           │
└──────────────┬───────────────────────┘
               │
               ▼
        ┌──────────────┐
        │ UI Updates   │
        │ via Provider │
        └──────────────┘
```

### Answer Checking Flow

```
User types answer
       │
       ▼
┌────────────────────────────┐
│ GamePage.onChanged()       │
│ calls checkAnswer()        │
└────────────┬───────────────┘
             │
             ▼
┌────────────────────────────────────┐
│ GameEngine.checkAnswer()           │
│                                    │
│ 1. Normalize user input            │
│ 2. Check exact match               │
│ 3. Check fuzzy match (>85%)        │
│ 4. If match: increment score       │
│ 5. Show success (1.5s)             │
│ 6. Generate new round              │
└────────────────────────────────────┘
```

## Core Components

### 1. GameEngine (Service)

**Location**: `lib/features/game/services/game_engine.dart`

**Responsibilities**:
- Generate game rounds
- Validate answers
- Manage game state
- Track score

**State Variables**:
```dart
GameState _state;          // loading, playing, correct, error
int _score;                // Player's score
List<Movie> _currentMovies; // Current round movies
List<Actor> _correctActors; // Valid answers
String _errorMessage;       // Error message (if any)
```

**Key Methods**:
| Method | Description |
|--------|-------------|
| `generateNewRound()` | Creates a new round with 2-5 movies |
| `checkAnswer()` | Validates user's guess |
| `skipRound()` | Skips current round |
| `retry()` | Retries after error |

### 2. TmdbApi (Data Layer)

**Location**: `lib/core/api/tmdb_api.dart`

**Responsibilities**:
- Communicate with TMDB API
- Parse JSON responses
- Handle network errors

**Key Methods**:
| Method | Endpoint | Returns |
|--------|----------|---------|
| `getPopularActors()` | `/person/popular` | `List<Actor>` |
| `getMoviesForActor()` | `/person/{id}/movie_credits` | `List<Movie>` |
| `getCastForMovie()` | `/movie/{id}/credits` | `List<Actor>` |
| `discoverPopularMovies()` | `/discover/movie` | `List<Movie>` |

### 3. Models (Data Structures)

**Movie Model**:
```dart
class Movie {
  final int id;
  final String title;
  final String? posterPath;

  String getPosterUrl(); // Returns full TMDB image URL
}
```

**Actor Model**:
```dart
class Actor {
  final int id;
  final String name;
  final String? profilePath;

  String getProfileUrl(); // Returns full TMDB image URL
}
```

## State Management

### Provider Pattern Implementation

**Setup** (`main.dart`):
```dart
ChangeNotifierProvider(
  create: (_) => GameEngine(),
  child: MaterialApp(
    home: GamePage(),
  ),
)
```

**Consuming State** (`game_page.dart`):
```dart
Consumer<GameEngine>(
  builder: (context, game, child) {
    // UI updates automatically when game state changes
    return Column(
      children: [
        Text('Score: ${game.score}'),
        MoviePosters(movies: game.currentMovies),
      ],
    );
  },
)
```

### State Transitions

```
LOADING → PLAYING → CORRECT → LOADING (loop)
   ↓
ERROR (if API fails)
   ↓
LOADING (on retry)
```

## API Integration

### TMDB API Configuration

**Authentication**: API key in `.env` file
```
TMDB_API_KEY=your_key_here
```

**Base URL**: `https://api.themoviedb.org/3`

**Image CDN**: `https://image.tmdb.org/t/p/w500{poster_path}`

### Error Handling

Errors are caught at two levels:

1. **API Level** (`TmdbApi`):
   - Throws exceptions on HTTP errors
   - Includes error details in exception message

2. **Service Level** (`GameEngine`):
   - Catches exceptions from API
   - Sets state to `ERROR`
   - Displays user-friendly message
   - Provides retry mechanism

## UI Layer

### Component Hierarchy

```
MaterialApp
  └── ChangeNotifierProvider<GameEngine>
       └── GamePage
            ├── Score Display
            ├── Game Content
            │    ├── MoviePosters
            │    │    └── MoviePosterCard (x2-5)
            │    ├── Input Field
            │    └── Skip Button
            └── Error/Loading States
```

### Responsive Design

**Movie Grid**:
- 2 movies: 2 columns
- 3+ movies: 3 columns
- Aspect ratio: 0.67 (standard poster ratio)

**Spacing**:
- Grid gap: 12px
- Screen padding: 16px
- Border radius: 12px

### Theme

**Colors**:
- Background: `#1a1a1a` (dark gray)
- Surface: `#2a2a2a` (lighter gray)
- Accent: Amber
- Text: White

**Typography**:
- Score: 24px, bold
- Title: 20px, semi-bold
- Input: 18px
- Hints: 16px

## Testing Strategy

### Unit Tests
- `StringUtils`: Test normalization and comparison
- `GameEngine`: Test answer validation logic
- Models: Test JSON serialization

### Widget Tests
- `MoviePosters`: Test grid layout
- `GamePage`: Test UI state changes

### Integration Tests
- Full game flow: Start → Answer → New Round
- Error scenarios: Network failure handling

## Performance Considerations

### Optimization Techniques

1. **Image Caching**: `CachedNetworkImage` caches posters locally
2. **Lazy Loading**: Images load on-demand
3. **Minimal Rebuilds**: Provider only rebuilds affected widgets
4. **Efficient Algorithms**: String normalization is O(n)

### Memory Management

- Images cached with LRU (Least Recently Used) policy
- Old game state is garbage collected
- No memory leaks from listeners (disposed properly)

## Security

### API Key Protection
- API key stored in `.env` (gitignored)
- Never committed to version control
- Loaded at runtime via `flutter_dotenv`

### Input Validation
- User input sanitized before comparison
- No SQL injection risk (API only, no database)
- No XSS risk (Flutter app, not web)

## Scalability

### Extensibility Points

1. **New Game Modes**:
   - Add methods to `GameEngine`
   - Create new page in `features/game/pages`

2. **Additional APIs**:
   - Add new service in `core/api`
   - Follow same pattern as `TmdbApi`

3. **Localization**:
   - Add `l10n` folder
   - Use Flutter's `intl` package

4. **Persistence**:
   - Add `repositories` layer
   - Use `sqflite` or `hive` for local storage

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| API calls fail | Missing/invalid API key | Check `.env` file |
| Images don't load | Network/CORS issue | Check internet connection |
| State not updating | Forgot `notifyListeners()` | Add to state mutations |
| Build errors | Missing dependencies | Run `flutter pub get` |

## Future Improvements

### Potential Enhancements

1. **Offline Mode**: Cache popular actors/movies
2. **Difficulty Levels**: Easy (2 movies) → Hard (5 movies)
3. **Hints System**: Reveal movie title or actor initials
4. **Leaderboard**: Track high scores (requires backend)
5. **Multiplayer**: Real-time challenges with friends
6. **Achievements**: Unlock badges for milestones

---

**Last Updated**: 2025-11-20
**Version**: 1.0.0
