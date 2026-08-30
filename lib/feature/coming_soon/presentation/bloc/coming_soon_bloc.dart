import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/coming_soon/domain/use_case/coming_soon_usecase.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/utiiity/get_it_locator.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';

import 'coming_soon_event.dart';

class ComingSoonBloc extends BaseBloc<ComingSoonEvent, MoviesResponse> {
  late final GetUpcomingMoviesUseCase _getUpcomingMoviesUseCase;
  bool _isFetchingNextPage = false;

  ComingSoonBloc() : super() {
    _getUpcomingMoviesUseCase = sl<GetUpcomingMoviesUseCase>();
    on<FetchUpcomingMoviesEvent>(_fetchUpcomingMovies);
    on<FetchNextUpcomingPageEvent>(_fetchNextPage);
  }

  Future<void> _fetchUpcomingMovies(
    FetchUpcomingMoviesEvent event,
    Emitter<BaseBlocState<MoviesResponse>> emit,
  ) async {
    await baseMethod(
      emit,
      () async {
        final result = await _getUpcomingMoviesUseCase.call();
        return result.fold(
          (error) {
            log("Exception : $error");
            return Left<AppException, MoviesResponse>(error);
          },
          (data) => Right<AppException, MoviesResponse>(data),
        );
      },
    );
  }

  // Appends the next page to the current results instead of replacing them,
  // so scrolling further down the list doesn't trigger a full-screen reload.
  Future<void> _fetchNextPage(
    FetchNextUpcomingPageEvent event,
    Emitter<BaseBlocState<MoviesResponse>> emit,
  ) async {
    final current = state.data;
    if (current == null || _isFetchingNextPage || current.page >= current.totalPages) {
      return;
    }

    _isFetchingNextPage = true;
    final result = await _getUpcomingMoviesUseCase.call(page: current.page + 1);
    result.fold(
      (error) => log("Exception : $error"),
      (nextPage) {
        emit(
          state.copyWith(
            status: BaseStatus.success,
            data: MoviesResponse(
              page: nextPage.page,
              results: [...current.results, ...nextPage.results],
              totalPages: nextPage.totalPages,
              totalResults: nextPage.totalResults,
            ),
          ),
        );
      },
    );
    _isFetchingNextPage = false;
  }
}
