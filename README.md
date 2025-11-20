# Movie Quiz 🎬

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A fun and addictive Flutter game where players guess actors who appeared in multiple films! Test your movie knowledge and discover fascinating connections between films.

## 📖 Table of Contents

- [Game Concept](#-game-concept)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Getting Started](#-getting-started)
- [How to Play](#-how-to-play)
- [Project Structure](#️-project-structure)
- [Technical Details](#-technical-details)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)

## 🎮 Game Concept

The game presents you with **2-5 movie posters**. These movies all have **at least one actor in common**. Your goal is to guess the name of an actor who appeared in all of these films!

### Example Round

```
Movies Shown:
- Fight Club
- Ocean's Eleven
- Inglourious Basterds

Correct Answer: Brad Pitt ✅
```

The game gets progressively more challenging as you advance, with more obscure movies and actors!

## ✨ Features

### Core Gameplay
- ⚡ **Instant validation** - Answers checked as you type
- 🎯 **Score tracking** - Keep track of your progress
- 🔄 **Infinite gameplay** - Unlimited rounds, no end!
- 🎲 **Random selection** - Different challenge every time

### Smart Matching
- 🔤 **Case insensitive** - "Brad Pitt" = "brad pitt"
- 🌍 **Accent tolerant** - "José García" = "jose garcia"
- 🎯 **Fuzzy matching** - Tolerates minor typos (85% similarity)
- ⏩ **Skip option** - Stuck? Skip to the next round

### User Experience
- 🎨 **Minimalist design** - Clean, distraction-free interface
- 🖼️ **High-quality posters** - Beautiful movie images from TMDB
- 📱 **Responsive layout** - Adapts to different screen sizes
- ⚡ **Fast loading** - Cached images for smooth experience

### Technical
- 🌐 **Real data** - Live data from The Movie Database (TMDB)
- 💾 **Image caching** - Efficient loading and offline support
- 🔒 **Secure** - API keys protected, no data collection
- 🧪 **Well-tested** - Unit and widget tests included

## 📸 Screenshots

> **Note**: Add screenshots here once the app is running

```
[Home Screen]  [Playing]  [Correct Answer]
```

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

## 📚 Documentation

Comprehensive documentation is available in the `/docs` folder:

- **[Architecture Guide](docs/ARCHITECTURE.md)** - Project structure and design patterns
- **[API Documentation](docs/API.md)** - TMDB API integration details
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute to the project

### Quick Links

| Topic | Documentation |
|-------|---------------|
| Getting started | [Installation](#-getting-started) |
| Game rules | [How to Play](#-how-to-play) |
| Code structure | [Architecture](docs/ARCHITECTURE.md) |
| API integration | [API Guide](docs/API.md) |
| Contributing | [Contributing](CONTRIBUTING.md) |

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Ways to Contribute

- 🐛 **Report bugs** - Found an issue? Let us know!
- 💡 **Suggest features** - Have an idea? We'd love to hear it!
- 📝 **Improve docs** - Help make documentation clearer
- 🔧 **Submit PRs** - Fix bugs or add features

### Getting Started

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes and commit: `git commit -m "feat: add my feature"`
4. Push to your fork: `git push origin feature/my-feature`
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 🐛 Known Issues & Limitations

| Issue | Impact | Workaround |
|-------|--------|------------|
| First load is slow | 3-5 second wait | Cache improves subsequent loads |
| Requires internet | Can't play offline | Offline mode planned for v2.0 |
| Some actor name variations not recognized | Rare edge cases | Try different spelling |
| Limited to popular actors | Fewer indie actors | Covers 99% of mainstream films |

## 🛣️ Roadmap

### Version 1.1 (In Progress)
- [ ] Performance optimizations
- [ ] Better error messages
- [ ] Loading animations

### Version 2.0 (Planned)
- [ ] **Difficulty modes** - Easy, Medium, Hard
- [ ] **Leaderboard** - Compare scores with friends
- [ ] **Timed challenges** - Race against the clock
- [ ] **Achievements** - Unlock badges and rewards
- [ ] **Dark/Light themes** - Choose your style
- [ ] **Offline mode** - Play without internet

### Version 3.0 (Ideas)
- [ ] Multiplayer mode
- [ ] Daily challenges
- [ ] Actor hints system
- [ ] Movie trivia
- [ ] Custom game modes

## 📊 Project Stats

- **Lines of Code**: ~1,000+
- **Test Coverage**: TBD
- **Dependencies**: 6 packages
- **Supported Platforms**: Android, iOS, Web

## ❓ FAQ

### Q: Do I need to pay for the TMDB API?
**A:** No, TMDB offers a free tier with generous rate limits (40 requests per 10 seconds).

### Q: Can I play offline?
**A:** Not yet. The game requires an internet connection to fetch movie data. Offline mode is planned for a future release.

### Q: How are the movies selected?
**A:** The game randomly selects a popular actor, then picks 2-5 of their movies (with filters for quality and release date).

### Q: Why isn't my answer accepted?
**A:** Make sure you're typing the actor's name correctly. The game is forgiving (case and accents don't matter), but it needs to be at least 85% similar to the correct name.

### Q: Can I contribute new features?
**A:** Absolutely! Check out [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 🔗 Useful Links

- [TMDB Website](https://www.themoviedb.org/) - Movie database
- [TMDB API Docs](https://developers.themoviedb.org/3) - API documentation
- [Flutter Docs](https://docs.flutter.dev/) - Flutter documentation
- [Dart Docs](https://dart.dev/guides) - Dart language guide

## 📄 License

This project is open source and available under the **MIT License**.

```
MIT License

Copyright (c) 2025 Movie Quiz Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

[Full license text in LICENSE file]
```

## 🙏 Acknowledgments

### Data & APIs
- Movie data provided by **[The Movie Database (TMDB)](https://www.themoviedb.org/)**
- Movie posters and images © their respective studios

### Technologies
- Built with **[Flutter](https://flutter.dev/)** - Google's UI toolkit
- Powered by **[Dart](https://dart.dev/)** programming language

### Inspiration
- Inspired by popular movie trivia games
- Special thanks to the Flutter community

## 📞 Support & Contact

### Need Help?

- 📖 **Documentation**: Check the [docs](docs/) folder
- 🐛 **Bug Reports**: [Open an issue](https://github.com/yourusername/MovieQuiz/issues)
- 💡 **Feature Requests**: [Start a discussion](https://github.com/yourusername/MovieQuiz/discussions)
- 📧 **Email**: [your-email@example.com](mailto:your-email@example.com)

### Community

- ⭐ **Star this repo** if you find it useful!
- 🔀 **Fork and contribute** to make it better
- 📣 **Share with friends** who love movies

---

<div align="center">

**Made with ❤️ using Flutter**

⭐ Star this repo if you enjoyed the game! ⭐

</div>
