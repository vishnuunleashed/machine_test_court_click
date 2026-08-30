import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/feature/search/domain/search_repository/search_repository.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';
import 'package:machine_test_court_click/utiiity/helpers/base_http_using_dio_with_error_handling.dart';

class SearchRepositoryImpl extends SearchRepository {
  final BaseHttp _http = BaseHttp();

  @override
  Future<Either<AppException, MoviesResponse>> searchMovies(String query) async {
    try {
      final response = await _http.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      final data = Map<String, dynamic>.from(response as Map);
      return Right(MoviesResponse.fromJson(data));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }
}
