import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';

abstract class HomeRepository {
  Future<Either<AppException, MoviesResponse>> getTrendingAllWeek();
  Future<Either<AppException, MoviesResponse>> getPopularMovies();
  Future<Either<AppException, MoviesResponse>> getNowPlayingMovies();
  Future<Either<AppException, MoviesResponse>> getTopRatedMovies();
}