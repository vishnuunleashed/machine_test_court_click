class MoviesResponse {
  final int page;
  final List<MovieResult> results;
  final int totalPages;
  final int totalResults;

  MoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) {
    final resultsList = (json['results'] as List? ?? const [])
        .map((item) => MovieResult.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();

    return MoviesResponse(
      page: json['page'] ?? 0,
      results: resultsList,
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results.map((item) => item.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}

class MovieResult {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String? title;
  final String? name;
  final String originalLanguage;
  final String? originalTitle;
  final String? originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? firstAirDate;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final String? mediaType;
  final List<String> originCountry;
  final bool? softcore;

  MovieResult({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    this.title,
    this.name,
    required this.originalLanguage,
    this.originalTitle,
    this.originalName,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    this.firstAirDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.mediaType,
    required this.originCountry,
    this.softcore,
  });

  factory MovieResult.fromJson(Map<String, dynamic> json) {
    return MovieResult(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'],
      genreIds: List<int>.from(
        (json['genre_ids'] as List? ?? const []).map((e) => int.tryParse(e.toString()) ?? 0),
      ),
      id: json['id'] ?? 0,
      title: json['title'],
      name: json['name'],
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'],
      originalName: json['original_name'],
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] is num) ? (json['popularity'] as num).toDouble() : 0.0,
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      firstAirDate: json['first_air_date'],
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] is num) ? (json['vote_average'] as num).toDouble() : 0.0,
      voteCount: json['vote_count'] ?? 0,
      mediaType: json['media_type'],
      originCountry: List<String>.from(
        (json['origin_country'] as List? ?? const []).map((e) => e.toString()),
      ),
      softcore: json['softcore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'id': id,
      'title': title,
      'name': name,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'original_name': originalName,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'first_air_date': firstAirDate,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'media_type': mediaType,
      'origin_country': originCountry,
      'softcore': softcore,
    };
  }
}
