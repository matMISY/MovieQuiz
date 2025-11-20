# TMDB API Integration Guide

## Table of Contents
- [Overview](#overview)
- [Getting Started](#getting-started)
- [API Endpoints](#api-endpoints)
- [Data Models](#data-models)
- [Usage Examples](#usage-examples)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [Best Practices](#best-practices)

## Overview

Movie Quiz integrates with **The Movie Database (TMDB)** API to fetch movie and actor data. TMDB provides a comprehensive, free REST API with extensive movie information.

### Why TMDB?

✅ **Free tier** with generous rate limits
✅ **Well-documented** API
✅ **Large database** of movies and actors
✅ **CDN-hosted images** for fast loading
✅ **Active community** and support

### API Documentation

- Official Docs: https://developers.themoviedb.org/3
- API Reference: https://developers.themoviedb.org/3/getting-started/introduction

## Getting Started

### 1. Create a TMDB Account

Visit [TMDB](https://www.themoviedb.org/) and sign up for a free account.

### 2. Request an API Key

1. Go to **Settings** → **API**
2. Click **Create` or `Request an API Key`
3. Choose **Developer** option
4. Fill in application details:
   - Application Name: `Movie Quiz`
   - Application URL: Your app URL or GitHub repo
   - Application Summary: Brief description
5. Accept the terms and submit

### 3. Configure Your App

Create a `.env` file in your project root:

```bash
TMDB_API_KEY=your_api_key_here
```

⚠️ **Important**: Never commit your API key to version control!

### 4. Load Environment Variables

The app automatically loads the API key from `.env` using `flutter_dotenv`:

```dart
await dotenv.load(fileName: ".env");
String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
```

## API Endpoints

Our app uses the following TMDB API endpoints:

### 1. Get Popular Actors

**Endpoint**: `GET /person/popular`

**Purpose**: Fetch a list of popular actors to use in the game

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your TMDB API key |
| `page` | integer | No | Page number (default: 1) |

**Request Example**:
```
GET https://api.themoviedb.org/3/person/popular?api_key=YOUR_KEY&page=1
```

**Response**:
```json
{
  "page": 1,
  "results": [
    {
      "id": 287,
      "name": "Brad Pitt",
      "profile_path": "/kU3B75TyRiCgE270EyZnHjfivoq.jpg",
      "known_for": [...]
    },
    ...
  ],
  "total_pages": 500,
  "total_results": 10000
}
```

### 2. Get Actor's Movie Credits

**Endpoint**: `GET /person/{person_id}/movie_credits`

**Purpose**: Fetch all movies an actor has appeared in

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your TMDB API key |
| `person_id` | integer | Yes | The actor's TMDB ID |

**Request Example**:
```
GET https://api.themoviedb.org/3/person/287/movie_credits?api_key=YOUR_KEY
```

**Response**:
```json
{
  "cast": [
    {
      "id": 550,
      "title": "Fight Club",
      "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
      "release_date": "1999-10-15",
      "character": "Tyler Durden"
    },
    ...
  ],
  "id": 287
}
```

### 3. Get Movie Credits (Cast)

**Endpoint**: `GET /movie/{movie_id}/credits`

**Purpose**: Fetch the full cast list for a specific movie

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your TMDB API key |
| `movie_id` | integer | Yes | The movie's TMDB ID |

**Request Example**:
```
GET https://api.themoviedb.org/3/movie/550/credits?api_key=YOUR_KEY
```

**Response**:
```json
{
  "id": 550,
  "cast": [
    {
      "id": 287,
      "name": "Brad Pitt",
      "character": "Tyler Durden",
      "profile_path": "/kU3B75TyRiCgE270EyZnHjfivoq.jpg"
    },
    {
      "id": 819,
      "name": "Edward Norton",
      "character": "The Narrator",
      "profile_path": "/5XBzD5WuTyVQZeS4VI25z2moMeY.jpg"
    },
    ...
  ]
}
```

### 4. Discover Movies

**Endpoint**: `GET /discover/movie`

**Purpose**: Discover popular movies (currently not used in main game flow)

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your TMDB API key |
| `page` | integer | No | Page number (default: 1) |
| `sort_by` | string | No | Sort criteria (e.g., `popularity.desc`) |
| `primary_release_date.gte` | string | No | Minimum release date |

**Request Example**:
```
GET https://api.themoviedb.org/3/discover/movie?api_key=YOUR_KEY&sort_by=popularity.desc&primary_release_date.gte=1970-01-01
```

## Data Models

### Movie Model

```dart
class Movie {
  final int id;              // TMDB movie ID
  final String title;         // Movie title
  final String? posterPath;   // Relative poster path

  String getPosterUrl() {
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}
```

### Actor Model

```dart
class Actor {
  final int id;              // TMDB person ID
  final String name;          // Actor's full name
  final String? profilePath;  // Relative profile photo path

  String getProfileUrl() {
    return 'https://image.tmdb.org/t/p/w500$profilePath';
  }
}
```

## Image URLs

### Image Base URL

TMDB hosts images on a CDN. The base URL is:
```
https://image.tmdb.org/t/p/{size}{file_path}
```

### Available Sizes

| Size | Dimensions | Use Case |
|------|------------|----------|
| `w92` | 92px width | Thumbnails |
| `w154` | 154px width | Small images |
| `w185` | 185px width | Profile pictures |
| `w342` | 342px width | Medium posters |
| `w500` | 500px width | **Large posters (our choice)** |
| `w780` | 780px width | HD posters |
| `original` | Original size | Full resolution |

### Our Configuration

We use **w500** for movie posters:
```dart
String posterUrl = 'https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg';
```

## Usage Examples

### Example 1: Fetch Popular Actors

```dart
final api = TmdbApi();
final actors = await api.getPopularActors(page: 1);

for (final actor in actors) {
  print('${actor.name} (ID: ${actor.id})');
}

// Output:
// Brad Pitt (ID: 287)
// Tom Hanks (ID: 31)
// ...
```

### Example 2: Get Actor's Movies

```dart
final api = TmdbApi();
final movies = await api.getMoviesForActor(287); // Brad Pitt

print('Brad Pitt has ${movies.length} movies');
for (final movie in movies.take(5)) {
  print('- ${movie.title}');
}

// Output:
// Brad Pitt has 87 movies
// - Fight Club
// - Inglourious Basterds
// - Once Upon a Time in Hollywood
// ...
```

### Example 3: Get Movie Cast

```dart
final api = TmdbApi();
final cast = await api.getCastForMovie(550); // Fight Club

print('Fight Club cast:');
for (final actor in cast.take(5)) {
  print('- ${actor.name}');
}

// Output:
// Fight Club cast:
// - Brad Pitt
// - Edward Norton
// - Helena Bonham Carter
// ...
```

### Example 4: Find Common Actors

```dart
final api = TmdbApi();

// Get cast for two movies
final cast1 = await api.getCastForMovie(550);  // Fight Club
final cast2 = await api.getCastForMovie(807);  // Se7en

// Find common actors
final names1 = cast1.map((a) => a.name).toSet();
final names2 = cast2.map((a) => a.name).toSet();
final common = names1.intersection(names2);

print('Common actors: ${common.join(", ")}');
// Output: Common actors: Brad Pitt
```

## Error Handling

### Common Errors

| Status Code | Error | Cause | Solution |
|-------------|-------|-------|----------|
| `401` | Unauthorized | Invalid API key | Check your `.env` file |
| `404` | Not Found | Invalid ID | Verify actor/movie ID exists |
| `429` | Too Many Requests | Rate limit exceeded | Wait and retry |
| `500` | Server Error | TMDB server issue | Retry later |

### Error Handling in Code

```dart
try {
  final actors = await api.getPopularActors();
} on Exception catch (e) {
  if (e.toString().contains('401')) {
    print('Invalid API key');
  } else if (e.toString().contains('429')) {
    print('Rate limit exceeded');
  } else {
    print('Unknown error: $e');
  }
}
```

### App Error Handling

The `GameEngine` catches all API errors and:
1. Sets state to `GameState.error`
2. Displays user-friendly message: "Connection error. Please check your internet connection."
3. Provides a "Retry" button

## Rate Limiting

### TMDB Rate Limits

- **Free Tier**: 40 requests per 10 seconds
- **No daily limit**

### Our Usage

During a typical game round, we make approximately:
- 1 request to get popular actors
- 1 request to get actor's movies
- 2-5 requests to get cast for each movie

**Total**: ~4-7 requests per round (well within limits)

### Best Practices

✅ Cache responses when possible
✅ Don't make parallel requests unnecessarily
✅ Handle 429 errors gracefully (exponential backoff)
❌ Don't poll endpoints repeatedly

## Best Practices

### 1. Security

```dart
// ✅ Good: Load from environment
final apiKey = dotenv.env['TMDB_API_KEY'];

// ❌ Bad: Hardcode in source
final apiKey = 'abc123xyz'; // NEVER DO THIS
```

### 2. Error Handling

```dart
// ✅ Good: Catch and handle errors
try {
  final data = await api.getPopularActors();
  return data;
} catch (e) {
  debugPrint('Error: $e');
  return [];
}

// ❌ Bad: Let errors crash the app
final data = await api.getPopularActors(); // May crash
```

### 3. Image Loading

```dart
// ✅ Good: Use cached network images
CachedNetworkImage(
  imageUrl: movie.getPosterUrl(),
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)

// ❌ Bad: Regular network image (no caching)
Image.network(movie.getPosterUrl())
```

### 4. Data Filtering

```dart
// ✅ Good: Filter invalid data
final movies = allMovies.where((m) =>
  m.posterPath != null &&
  m.posterPath!.isNotEmpty
).toList();

// ❌ Bad: Assume all data is valid
final movies = allMovies; // May contain nulls
```

## Testing API Integration

### Manual Testing

1. **Test API Key**:
   ```bash
   curl "https://api.themoviedb.org/3/person/popular?api_key=YOUR_KEY"
   ```

2. **Check Response**:
   - Should return JSON with 200 status
   - Should contain `results` array

### Automated Testing

```dart
test('TmdbApi fetches popular actors', () async {
  final api = TmdbApi();
  final actors = await api.getPopularActors();

  expect(actors, isNotEmpty);
  expect(actors.first.name, isNotEmpty);
});
```

## Troubleshooting

### Issue: "Invalid API key"

**Symptoms**: 401 errors, API calls fail

**Solutions**:
1. Verify `.env` file exists
2. Check `TMDB_API_KEY` is correct
3. Ensure no extra spaces in `.env`
4. Restart app to reload environment

### Issue: "Images not loading"

**Symptoms**: Posters show error icon

**Solutions**:
1. Check internet connection
2. Verify `posterPath` is not null
3. Check TMDB CDN status
4. Try different image size (w500 → w342)

### Issue: "No common actors found"

**Symptoms**: Endless loading, can't generate round

**Solutions**:
1. Select actors with more movies
2. Increase movie pool (change filters)
3. Check API responses contain valid cast data

## Additional Resources

### Official Documentation
- [TMDB API Docs](https://developers.themoviedb.org/3)
- [API Authentication](https://developers.themoviedb.org/3/getting-started/authentication)
- [Image Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)

### Community Resources
- [TMDB API Forum](https://www.themoviedb.org/talk/category/5047958519c29526b50017d6)
- [Stack Overflow Tag](https://stackoverflow.com/questions/tagged/themoviedb)

### Alternative APIs

If TMDB doesn't meet your needs, consider:
- **OMDb API**: Similar to TMDB, requires API key
- **IMDb Non-Commercial**: Limited, requires approval
- **TVMaze API**: Primarily TV shows

---

**Last Updated**: 2025-11-20
**TMDB API Version**: v3
