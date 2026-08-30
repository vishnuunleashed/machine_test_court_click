import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/coming_soon/domain/coming_soon_repository/coming_soon_repository.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';
import 'package:machine_test_court_click/utiiity/helpers/base_http_using_dio_with_error_handling.dart';

class ComingSoonRepositoryImpl extends ComingSoonRepository {
  final BaseHttp _http = BaseHttp();

  @override
  Future<Either<AppException, MoviesResponse>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _http.get('/movie/upcoming', queryParameters: {'page': page});
      final data = Map<String, dynamic>.from(response as Map);
      return Right(MoviesResponse.fromJson(data));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }
}
