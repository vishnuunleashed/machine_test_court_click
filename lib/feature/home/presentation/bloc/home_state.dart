import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';

class HomeState {
  final MoviesResponse? trendingAllWeek;
  final MoviesResponse? popularMovies;
  final MoviesResponse? nowPlayingMovies;
  final MoviesResponse? topRatedMovies;

  const HomeState({
    this.trendingAllWeek,
    this.popularMovies,
    this.nowPlayingMovies,
    this.topRatedMovies,
  });

  HomeState copyWith({
    MoviesResponse? trendingAllWeek,
    MoviesResponse? popularMovies,
    MoviesResponse? nowPlayingMovies,
    MoviesResponse? topRatedMovies,
  }) {
    return HomeState(
      trendingAllWeek: trendingAllWeek ?? this.trendingAllWeek,
      popularMovies: popularMovies ?? this.popularMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }
}