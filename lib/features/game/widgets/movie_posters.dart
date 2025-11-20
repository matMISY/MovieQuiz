import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/movie.dart';

/// A widget that displays a grid of movie posters.
///
/// This widget automatically adapts its layout based on the number of movies:
/// - 2 movies or less: 2 columns
/// - 3+ movies: 3 columns
///
/// Each poster is displayed using [CachedNetworkImage] for efficient loading
/// and caching. Posters have rounded corners and a subtle shadow effect.
///
/// Grid specifications:
/// - Aspect ratio: 0.67 (standard movie poster ratio ~2:3)
/// - Spacing: 12px between posters
/// - Border radius: 12px
///
/// Example usage:
/// ```dart
/// MoviePosters(
///   movies: [movie1, movie2, movie3],
/// )
/// ```
class MoviePosters extends StatelessWidget {
  /// The list of movies to display
  final List<Movie> movies;

  /// Creates a [MoviePosters] widget.
  ///
  /// The [movies] parameter is required and should contain 2-5 movies.
  const MoviePosters({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine grid layout based on number of movies
        // 2 movies or less: 2 columns, 3+ movies: 3 columns
        int crossAxisCount = movies.length <= 2 ? 2 : 3;

        // Standard movie poster aspect ratio (~2:3)
        double childAspectRatio = 0.67;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MoviePosterCard(movie: movies[index]);
          },
        );
      },
    );
  }
}

/// A card widget that displays a single movie poster.
///
/// This internal widget handles:
/// - Image loading with [CachedNetworkImage]
/// - Loading placeholder with spinner
/// - Error fallback with movie title and icon
/// - Rounded corners and shadow styling
///
/// The poster is loaded from TMDB's CDN and cached locally for performance.
class _MoviePosterCard extends StatelessWidget {
  /// The movie to display
  final Movie movie;

  const _MoviePosterCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: movie.getPosterUrl(),
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[800],
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[800],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    movie.title,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
