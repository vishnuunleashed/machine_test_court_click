import 'package:get_it/get_it.dart';
import 'package:machine_test_court_click/feature/coming_soon/data/coming_soon_repository_impl/coming_soon_repository_impl.dart';
import 'package:machine_test_court_click/feature/coming_soon/domain/coming_soon_repository/coming_soon_repository.dart';
import 'package:machine_test_court_click/feature/coming_soon/domain/use_case/coming_soon_usecase.dart';
import 'package:machine_test_court_click/feature/home/data/home_repository_impl/home_repository_impl.dart';
import 'package:machine_test_court_click/feature/home/domain/home_respository/home_repository.dart';
import 'package:machine_test_court_click/feature/home/domain/use_case/home_usecase.dart';
import 'package:machine_test_court_click/feature/search/data/search_repository_impl/search_repository_impl.dart';
import 'package:machine_test_court_click/feature/search/domain/search_repository/search_repository.dart';
import 'package:machine_test_court_click/feature/search/domain/use_case/search_usecase.dart';

import 'helpers/base_http_using_dio_with_error_handling.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<BaseHttp>(() => BaseHttp());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());

  sl.registerLazySingleton<GetTrendingAllWeekUseCase>(
    () => GetTrendingAllWeekUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetPopularMoviesUseCase>(
    () => GetPopularMoviesUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetNowPlayingMoviesUseCase>(
    () => GetNowPlayingMoviesUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetTopRatedMoviesUseCase>(
    () => GetTopRatedMoviesUseCase(sl<HomeRepository>()),
  );

  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl());
  sl.registerLazySingleton<SearchMoviesUseCase>(
    () => SearchMoviesUseCase(sl<SearchRepository>()),
  );

  sl.registerLazySingleton<ComingSoonRepository>(() => ComingSoonRepositoryImpl());
  sl.registerLazySingleton<GetUpcomingMoviesUseCase>(
    () => GetUpcomingMoviesUseCase(sl<ComingSoonRepository>()),
  );
}