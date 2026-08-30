import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/coming_soon/domain/use_case/coming_soon_usecase.dart';
import 'package:machine_test_court_click/feature/coming_soon/presentation/bloc/coming_soon_bloc.dart';
import 'package:machine_test_court_click/feature/coming_soon/presentation/bloc/coming_soon_event.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/utiiity/get_it_locator.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUpcomingMoviesUseCase extends Mock implements GetUpcomingMoviesUseCase {}

MovieResult _movie(int id, String title) => MovieResult(
      adult: false,
      genreIds: const [],
      id: id,
      title: title,
      originalLanguage: 'en',
      overview: 'overview',
      popularity: 1,
      video: false,
      voteAverage: 0,
      voteCount: 0,
      originCountry: const [],
    );

void main() {
  late MockGetUpcomingMoviesUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetUpcomingMoviesUseCase();
    // ComingSoonBloc pulls its use case from the shared service locator
    // rather than a constructor parameter, so the mock is registered there.
    sl.registerLazySingleton<GetUpcomingMoviesUseCase>(() => mockUseCase);
  });

  tearDown(() async {
    await sl.reset();
  });

  group('ComingSoonBloc', () {
    blocTest<ComingSoonBloc, BaseBlocState<MoviesResponse>>(
      'emits [loading, success] with results when the fetch succeeds',
      setUp: () {
        when(() => mockUseCase.call(page: any(named: 'page'))).thenAnswer(
          (_) async => Right(
            MoviesResponse(
              page: 1,
              results: [_movie(1, 'Movie A')],
              totalPages: 2,
              totalResults: 2,
            ),
          ),
        );
      },
      build: () => ComingSoonBloc(),
      act: (bloc) => bloc.add(FetchUpcomingMoviesEvent()),
      expect: () => [
        isA<BaseBlocState<MoviesResponse>>().having((s) => s.status, 'status', BaseStatus.loading),
        isA<BaseBlocState<MoviesResponse>>()
            .having((s) => s.status, 'status', BaseStatus.success)
            .having((s) => s.data?.results.length, 'results length', 1),
      ],
    );

    blocTest<ComingSoonBloc, BaseBlocState<MoviesResponse>>(
      'emits [loading, failure] when the fetch fails',
      setUp: () {
        when(() => mockUseCase.call(page: any(named: 'page')))
            .thenAnswer((_) async => const Left(AppException(message: 'network error')));
      },
      build: () => ComingSoonBloc(),
      act: (bloc) => bloc.add(FetchUpcomingMoviesEvent()),
      expect: () => [
        isA<BaseBlocState<MoviesResponse>>().having((s) => s.status, 'status', BaseStatus.loading),
        isA<BaseBlocState<MoviesResponse>>()
            .having((s) => s.status, 'status', BaseStatus.failure)
            .having((s) => s.exception?.message, 'exception message', 'network error'),
      ],
    );

    blocTest<ComingSoonBloc, BaseBlocState<MoviesResponse>>(
      'appends the next page instead of replacing existing results',
      setUp: () {
        when(() => mockUseCase.call(page: any(named: 'page'))).thenAnswer((invocation) async {
          final page = invocation.namedArguments[#page] as int;
          if (page == 1) {
            return Right(
              MoviesResponse(page: 1, results: [_movie(1, 'Movie A')], totalPages: 2, totalResults: 2),
            );
          }
          return Right(
            MoviesResponse(page: 2, results: [_movie(2, 'Movie B')], totalPages: 2, totalResults: 2),
          );
        });
      },
      build: () => ComingSoonBloc(),
      act: (bloc) async {
        bloc.add(FetchUpcomingMoviesEvent());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(FetchNextUpcomingPageEvent());
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        expect(bloc.state.data?.page, 2);
        expect(bloc.state.data?.results.map((m) => m.title).toList(), ['Movie A', 'Movie B']);
      },
    );
  });
}
