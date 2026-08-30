import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/coming_soon/domain/coming_soon_repository/coming_soon_repository.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';

class GetUpcomingMoviesUseCase {
  GetUpcomingMoviesUseCase(this._repository);

  final ComingSoonRepository _repository;

  Future<Either<AppException, MoviesResponse>> call({int page = 1}) =>
      _repository.getUpcomingMovies(page: page);
}
