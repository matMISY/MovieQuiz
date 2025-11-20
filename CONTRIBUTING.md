# Contributing to Movie Quiz

Thank you for considering contributing to Movie Quiz! This document provides guidelines and instructions for contributing to this project.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive experience for everyone. We expect all contributors to:

- Be respectful and considerate
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards other contributors

### Unacceptable Behavior

- Harassment, trolling, or discriminatory comments
- Publishing others' private information
- Disruptive or inappropriate behavior
- Any conduct that could reasonably be considered inappropriate

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- Flutter SDK (>= 3.0.0)
- Dart SDK
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- A TMDB API key ([get one here](https://www.themoviedb.org/settings/api))

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/MovieQuiz.git
   cd MovieQuiz
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/MovieQuiz.git
   ```

## Development Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure Environment

Create a `.env` file:

```bash
cp .env.example .env
```

Edit `.env` and add your TMDB API key:

```
TMDB_API_KEY=your_actual_api_key_here
```

### 3. Verify Setup

Run the app:

```bash
flutter run
```

Run tests:

```bash
flutter test
```

## How to Contribute

### Reporting Bugs

Before creating a bug report:

1. **Check existing issues** to avoid duplicates
2. **Verify the bug** is reproducible
3. **Collect information**: Flutter version, OS, error messages

When filing a bug report, include:

- **Clear title** describing the issue
- **Steps to reproduce** the bug
- **Expected behavior** vs. **actual behavior**
- **Screenshots** or **video** (if applicable)
- **Error messages** or **stack traces**
- **Environment details**: Flutter version, device/emulator

Example:

```markdown
**Title**: App crashes when skipping round without internet

**Description**:
When I click "Skip" while offline, the app crashes.

**Steps to Reproduce**:
1. Disconnect from internet
2. Open app
3. Click "Skip this round"
4. App crashes

**Expected**: Error message or retry prompt
**Actual**: App crashes with exception

**Environment**:
- Flutter 3.10.0
- Android 12
- Pixel 5 emulator

**Error Log**:
```
[ERROR] Unhandled exception: SocketException...
```
```

### Suggesting Features

Before suggesting a feature:

1. **Check existing feature requests**
2. **Consider if it fits** the project's scope
3. **Think about implementation** complexity

When suggesting a feature, include:

- **Clear description** of the feature
- **Use case**: Why is this useful?
- **Proposed implementation** (if you have ideas)
- **Mockups or examples** (if applicable)

Example:

```markdown
**Feature**: Timed Challenge Mode

**Description**:
Add a mode where players have 30 seconds to guess the actor.

**Use Case**:
Adds excitement and replayability for experienced players.

**Implementation Ideas**:
- Add timer widget to GamePage
- Track time in GameEngine
- Show "Time's up!" message
- Option to enable/disable in settings

**Mockup**:
[Attach screenshot or sketch]
```

## Coding Standards

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style):

- **Use camelCase** for variables and methods
- **Use PascalCase** for classes and types
- **Use snake_case** for file names
- **Use underscores** for private members (`_privateMethod`)

### Code Organization

```dart
// 1. Imports (grouped and sorted)
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../services/api.dart';

// 2. Class definition
class MyWidget extends StatelessWidget {
  // 3. Constants
  static const double defaultPadding = 16.0;

  // 4. Fields
  final String title;
  final VoidCallback? onPressed;

  // 5. Constructor
  const MyWidget({
    super.key,
    required this.title,
    this.onPressed,
  });

  // 6. Overrides
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // 7. Public methods
  void publicMethod() {}

  // 8. Private methods
  void _privateMethod() {}
}
```

### Documentation

Use **DartDoc** comments for public APIs:

```dart
/// Fetches movies for a specific actor.
///
/// Returns a list of [Movie] objects filtered by:
/// - Movies released after 1970
/// - Movies with valid poster images
///
/// Throws [Exception] if the API request fails.
///
/// Example:
/// ```dart
/// final movies = await api.getMoviesForActor(287);
/// ```
Future<List<Movie>> getMoviesForActor(int actorId) async {
  // Implementation
}
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Class | PascalCase | `GameEngine`, `MoviePoster` |
| Method | camelCase | `checkAnswer()`, `generateRound()` |
| Variable | camelCase | `currentScore`, `movieList` |
| Constant | camelCase | `maxAttempts`, `apiTimeout` |
| Private | Leading underscore | `_apiKey`, `_setState()` |
| File | snake_case | `game_engine.dart`, `movie_posters.dart` |

## Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```bash
feat(game): add timed challenge mode

Implement a 30-second timer for each round.
Players must answer before time runs out.

Closes #45
```

```bash
fix(ui): correct poster grid layout on tablets

The poster grid was not displaying correctly on
large screens. Adjusted aspect ratio calculation.

Fixes #23
```

```bash
docs(api): add TMDB integration guide

Created comprehensive documentation for TMDB API
integration including examples and troubleshooting.
```

### Best Practices

✅ **Do**:
- Write clear, concise messages
- Use present tense ("add" not "added")
- Keep subject under 50 characters
- Explain "why" in the body, not "what"
- Reference issues when applicable

❌ **Don't**:
- Use vague messages ("fix stuff", "update")
- Commit commented-out code
- Mix unrelated changes in one commit
- Include large binary files

## Pull Request Process

### Before Submitting

1. **Update your fork**:
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-awesome-feature
   ```

3. **Make your changes** and commit:
   ```bash
   git add .
   git commit -m "feat: add awesome feature"
   ```

4. **Run tests**:
   ```bash
   flutter test
   ```

5. **Check code formatting**:
   ```bash
   dart format .
   ```

6. **Run linter**:
   ```bash
   flutter analyze
   ```

### Submitting the PR

1. **Push to your fork**:
   ```bash
   git push origin feature/my-awesome-feature
   ```

2. **Open a Pull Request** on GitHub

3. **Fill out the PR template**:

   ```markdown
   ## Description
   Brief description of what this PR does.

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Refactoring

   ## Testing
   - [ ] I have tested these changes locally
   - [ ] I have added/updated tests
   - [ ] All tests pass

   ## Checklist
   - [ ] Code follows project style guidelines
   - [ ] Comments added for complex logic
   - [ ] Documentation updated
   - [ ] No new warnings from `flutter analyze`

   ## Related Issues
   Closes #123
   ```

### Review Process

1. **Maintainers review** your code
2. **Address feedback** by pushing new commits
3. **Once approved**, your PR will be merged

### After Merge

1. **Delete your branch**:
   ```bash
   git branch -d feature/my-awesome-feature
   git push origin --delete feature/my-awesome-feature
   ```

2. **Update your fork**:
   ```bash
   git checkout main
   git pull upstream main
   ```

## Testing

### Writing Tests

#### Unit Tests

```dart
// test/string_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_quiz/core/utils/string_utils.dart';

void main() {
  group('StringUtils', () {
    test('normalize removes accents', () {
      expect(StringUtils.normalize('José'), 'jose');
      expect(StringUtils.normalize('Björk'), 'bjork');
    });

    test('areEqual is case insensitive', () {
      expect(StringUtils.areEqual('Brad Pitt', 'brad pitt'), true);
      expect(StringUtils.areEqual('Tom Hanks', 'Tim Hanks'), false);
    });
  });
}
```

#### Widget Tests

```dart
// test/movie_posters_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_quiz/features/game/widgets/movie_posters.dart';

void main() {
  testWidgets('MoviePosters displays correct number of posters', (tester) async {
    final movies = [movie1, movie2, movie3];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoviePosters(movies: movies),
        ),
      ),
    );

    expect(find.byType(CachedNetworkImage), findsNWidgets(3));
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/string_utils_test.dart

# Run with coverage
flutter test --coverage
```

## Documentation

### When to Update Documentation

Update documentation when you:

- Add a new feature
- Change existing functionality
- Fix a bug that affects usage
- Add or modify public APIs

### Documentation Locations

| Type | Location |
|------|----------|
| API docs | `docs/API.md` |
| Architecture | `docs/ARCHITECTURE.md` |
| User guide | `README.md` |
| Code docs | Inline DartDoc comments |

### Documentation Standards

- Keep it concise and clear
- Include code examples
- Add screenshots for UI changes
- Update the changelog

## Need Help?

### Resources

- [Project Documentation](README.md)
- [Architecture Guide](docs/ARCHITECTURE.md)
- [API Reference](docs/API.md)
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Docs](https://dart.dev/guides)

### Questions?

- Open an [issue](https://github.com/YOUR_REPO/issues) with the "question" label
- Check [existing discussions](https://github.com/YOUR_REPO/discussions)

---

**Thank you for contributing to Movie Quiz!** 🎬

Every contribution, no matter how small, is valued and appreciated.
