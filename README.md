# Movie Quiz 🎬

A fun Flutter game where players guess actors who appeared in multiple films!

## 🎮 Game Concept

The game presents you with 2-5 movie posters. These movies all have at least one actor in common. Your goal is to guess the name of an actor who appeared in all of these films!

### Features
- ⚡ Instant validation as you type
- 🎯 Score tracking
- 🔄 Infinite gameplay loop
- 🎨 Clean, minimalist design
- 🌐 Real movie data from TMDB

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK
- A TMDB API key (free)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/MovieQuiz.git
   cd MovieQuiz
   ```

2. **Get TMDB API Key**
   - Visit [TMDB](https://www.themoviedb.org/)
   - Create a free account
   - Go to Settings > API
   - Request an API key (choose "Developer" option)

3. **Configure environment**
   ```bash
   cp .env.example .env
   ```

   Then edit `.env` and add your API key:
   ```
   TMDB_API_KEY=your_actual_api_key_here
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web (experimental)

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── api/
│   │   └── tmdb_api.dart          # TMDB API service
│   ├── models/
│   │   ├── movie.dart             # Movie data model
│   │   └── actor.dart             # Actor data model
│   └── utils/
│       └── string_utils.dart      # String normalization utilities
├── features/
│   └── game/
│       ├── pages/
│       │   └── game_page.dart     # Main game screen
│       ├── widgets/
│       │   └── movie_posters.dart # Movie poster grid
│       └── services/
│           └── game_engine.dart   # Game logic & state
└── main.dart                       # App entry point
```

## 🎯 How to Play

1. Look at the movie posters displayed
2. Think of an actor who appeared in ALL of them
3. Type the actor's name in the text field
4. The game validates automatically as you type!
5. Score increases with each correct answer
6. A new challenge appears instantly after success

### Answer Validation

The game is forgiving with your answers:
- ✅ Case insensitive
- ✅ Accent tolerant (José = Jose)
- ✅ Fuzzy matching (85% similarity threshold)

## 🔧 Technical Details

### Dependencies

- **provider** - State management
- **http** - API requests
- **cached_network_image** - Image caching
- **flutter_dotenv** - Environment variables
- **string_similarity** - Fuzzy string matching

### API Endpoints Used

- `/person/popular` - Get popular actors
- `/person/{id}/movie_credits` - Get movies for an actor
- `/movie/{id}/credits` - Get cast for a movie
- `/discover/movie` - Discover popular movies

### Game Logic

1. Select a random popular actor
2. Fetch their filmography
3. Filter movies (released after 1970, has poster)
4. Select 2-5 random movies
5. Verify common actors across all selected movies
6. Accept any common actor as valid answer

## 🔒 Security

- API keys stored in `.env` (not committed to git)
- No personal data collected
- No analytics in MVP

## 🚧 Future Enhancements

- [ ] Difficulty modes (more films, obscure actors)
- [ ] Leaderboard system
- [ ] Timed challenges
- [ ] Dark/Light theme toggle
- [ ] Actor name autocomplete
- [ ] Hint system
- [ ] Multi-language support

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Credits

- Movie data provided by [The Movie Database (TMDB)](https://www.themoviedb.org/)
- Built with [Flutter](https://flutter.dev/)

## 🐛 Known Issues

- First round may take a few seconds to load (API calls)
- Requires internet connection to play
- Some obscure actor names may not be recognized

## 📞 Support

If you encounter any issues or have suggestions, please [open an issue](https://github.com/yourusername/MovieQuiz/issues) on GitHub.

---

Made with ❤️ using Flutter
