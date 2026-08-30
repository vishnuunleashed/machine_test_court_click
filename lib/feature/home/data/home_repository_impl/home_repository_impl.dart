import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/feature/home/domain/home_respository/home_repository.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';
import 'package:machine_test_court_click/utiiity/helpers/base_http_using_dio_with_error_handling.dart';

class HomeRepositoryImpl extends HomeRepository {
  final BaseHttp _http = BaseHttp();

  @override
  Future<Either<AppException, MoviesResponse>> getTrendingAllWeek() async {
    try {
      final response = await _http.get('/trending/all/week');
      final data = Map<String, dynamic>.from(response as Map);
      return Right(MoviesResponse.fromJson(data));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, MoviesResponse>> getPopularMovies() async {
    try {
      final response = await _http.get('/movie/popular');
      final data = Map<String, dynamic>.from(response as Map);
      return Right(MoviesResponse.fromJson(data));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, MoviesResponse>> getNowPlayingMovies() async {
    try {
      final response = await _http.get('/movie/now_playing');
      final data = Map<String, dynamic>.from(response as Map);
      return Right(MoviesResponse.fromJson(data));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, MoviesResponse>> getTopRatedMovies() async {
    try {
      final response = await _http.get('/movie/top_rated');
      final data = Map<String, dynamic>.from(response as Map);
      return Right(MoviesResponse.fromJson(data));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }
}