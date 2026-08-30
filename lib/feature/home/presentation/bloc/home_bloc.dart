import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/home/domain/use_case/home_usecase.dart';
import 'package:machine_test_court_click/utiiity/get_it_locator.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  late final GetTrendingAllWeekUseCase _getTrendingAllWeekUseCase;
  late final GetPopularMoviesUseCase _getPopularMoviesUseCase;
  late final GetNowPlayingMoviesUseCase _getNowPlayingMoviesUseCase;
  late final GetTopRatedMoviesUseCase _getTopRatedMoviesUseCase;

  HomeBloc() : super() {
    _getTrendingAllWeekUseCase = sl<GetTrendingAllWeekUseCase>();
    _getPopularMoviesUseCase = sl<GetPopularMoviesUseCase>();
    _getNowPlayingMoviesUseCase = sl<GetNowPlayingMoviesUseCase>();
    _getTopRatedMoviesUseCase = sl<GetTopRatedMoviesUseCase>();

    on<FetchTrendingAllWeekEvent>(_fetchTrendingAllWeek);
    on<FetchPopularMoviesEvent>(_fetchPopularMovies);
    on<FetchNowPlayingMoviesEvent>(_fetchNowPlayingMovies);
    on<FetchTopRatedMoviesEvent>(_fetchTopRatedMovies);
  }

  Future<void> _fetchTrendingAllWeek(
    FetchTrendingAllWeekEvent event,
    Emitter<BaseBlocState<HomeState>> emit,
  ) async {
    await baseMethod(
      emit,
      () async {

        final result = await _getTrendingAllWeekUseCase.call();
        return result.fold(
          (error) {
            log("Exception : $error");
            return Left<AppException, HomeState>(error);
          },
          (data) {
            final current = state.data ?? const HomeState();
            return Right<AppException, HomeState>(
              current.copyWith(trendingAllWeek: data),
            );
          },
        );
      },
    );
  }

  Future<void> _fetchPopularMovies(
    FetchPopularMoviesEvent event,
    Emitter<BaseBlocState<HomeState>> emit,
  ) async {
    await baseMethod(
      emit,
      () async {
        final result = await _getPopularMoviesUseCase.call();
        return result.fold(
          (error) => Left<AppException, HomeState>(error),
          (data) {
            final current = state.data ?? const HomeState();
            return Right<AppException, HomeState>(
              current.copyWith(popularMovies: data),
            );
          },
        );
      },
    );
  }

  Future<void> _fetchNowPlayingMovies(
    FetchNowPlayingMoviesEvent event,
    Emitter<BaseBlocState<HomeState>> emit,
  ) async {
    await baseMethod(
      emit,
      () async {
        final result = await _getNowPlayingMoviesUseCase.call();
        return result.fold(
          (error) => Left<AppException, HomeState>(error),
          (data) {
            final current = state.data ?? const HomeState();
            return Right<AppException, HomeState>(
              current.copyWith(nowPlayingMovies: data),
            );
          },
        );
      },
    );
  }

  Future<void> _fetchTopRatedMovies(
    FetchTopRatedMoviesEvent event,
    Emitter<BaseBlocState<HomeState>> emit,
  ) async {
    await baseMethod(
      emit,
      () async {
        final result = await _getTopRatedMoviesUseCase.call();
        return result.fold(
          (error) => Left<AppException, HomeState>(error),
          (data) {
            final current = state.data ?? const HomeState();
            return Right<AppException, HomeState>(
              current.copyWith(topRatedMovies: data),
            );
          },
        );
      },
    );
  }
}