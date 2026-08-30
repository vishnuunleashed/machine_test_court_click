import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/feature/search/domain/search_repository/search_repository.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';

class SearchMoviesUseCase {
  SearchMoviesUseCase(this._repository);

  final SearchRepository _repository;

  Future<Either<AppException, MoviesResponse>> call(String query) =>
      _repository.searchMovies(query);
}
