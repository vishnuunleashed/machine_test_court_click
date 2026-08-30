import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';

abstract class ComingSoonRepository {
  Future<Either<AppException, MoviesResponse>> getUpcomingMovies({int page = 1});
}
