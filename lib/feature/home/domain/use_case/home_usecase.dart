import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/feature/home/domain/home_respository/home_repository.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';

class GetTrendingAllWeekUseCase {
  GetTrendingAllWeekUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<AppException, MoviesResponse>> call() =>
      _repository.getTrendingAllWeek();
}

class GetPopularMoviesUseCase {
  GetPopularMoviesUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<AppException, MoviesResponse>> call() =>
      _repository.getPopularMovies();
}

class GetNowPlayingMoviesUseCase {
  GetNowPlayingMoviesUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<AppException, MoviesResponse>> call() =>
      _repository.getNowPlayingMovies();
}

class GetTopRatedMoviesUseCase {
  GetTopRatedMoviesUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<AppException, MoviesResponse>> call() =>
      _repository.getTopRatedMovies();
}
