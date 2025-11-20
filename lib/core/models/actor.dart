/// Represents an actor from The Movie Database (TMDB).
///
/// This model contains the essential information about an actor,
/// including their ID, name, and profile photo.
///
/// Example usage:
/// ```dart
/// final actor = Actor(
///   id: 287,
///   name: 'Brad Pitt',
///   profilePath: '/kU3B75TyRiCgE270EyZnHjfivoq.jpg',
/// );
/// print(actor.getProfileUrl()); // Full TMDB profile image URL
/// ```
class Actor {
  /// The unique TMDB actor/person ID.
  final int id;

  /// The actor's full name.
  final String name;

  /// The relative path to the actor's profile photo on TMDB.
  ///
  /// This will be null if no profile photo is available.
  /// Use [getProfileUrl] to get the full URL.
  final String? profilePath;

  /// Creates an [Actor] instance.
  ///
  /// The [id] and [name] are required, while [profilePath] is optional.
  Actor({
    required this.id,
    required this.name,
    this.profilePath,
  });

  /// Creates an [Actor] from a JSON object returned by the TMDB API.
  ///
  /// Expected JSON format:
  /// ```json
  /// {
  ///   "id": 287,
  ///   "name": "Brad Pitt",
  ///   "profile_path": "/kU3B75TyRiCgE270EyZnHjfivoq.jpg"
  /// }
  /// ```
  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePath: json['profile_path'] as String?,
    );
  }

  /// Converts this [Actor] to a JSON object.
  ///
  /// Returns a map that can be serialized to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
    };
  }

  /// Returns the full URL to the actor's profile image.
  ///
  /// The profile image is fetched from TMDB's CDN at w500 resolution.
  /// Returns an empty string if no profile path is available.
  ///
  /// Example return value:
  /// `https://image.tmdb.org/t/p/w500/kU3B75TyRiCgE270EyZnHjfivoq.jpg`
  String getProfileUrl() {
    if (profilePath == null) return '';
    return 'https://image.tmdb.org/t/p/w500$profilePath';
  }
}
