import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/feature/search/domain/use_case/search_usecase.dart';
import 'package:machine_test_court_click/utiiity/get_it_locator.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';

import 'search_event.dart';

const _debounceDuration = Duration(milliseconds: 400);

class SearchBloc extends BaseBloc<SearchEvent, MoviesResponse> {
  late final SearchMoviesUseCase _searchMoviesUseCase;

  SearchBloc() : super() {
    _searchMoviesUseCase = sl<SearchMoviesUseCase>();
    on<SearchQueryChanged>(_onQueryChanged, transformer: _debounceRestartable(_debounceDuration));
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<BaseBlocState<MoviesResponse>> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const BaseBlocState());
      return;
    }

    await baseMethod(
      emit,
      () async {
        final result = await _searchMoviesUseCase.call(query);
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
}

// Waits for a pause of [duration] with no new events before letting the
// latest one through, so typing doesn't fire a request per keystroke.
EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) {
    return events.transform(_DebounceStreamTransformer<E>(duration)).asyncExpand(mapper);
  };
}

class _DebounceStreamTransformer<E> extends StreamTransformerBase<E, E> {
  _DebounceStreamTransformer(this.duration);

  final Duration duration;

  @override
  Stream<E> bind(Stream<E> stream) {
    late StreamController<E> controller;
    Timer? timer;

    controller = StreamController<E>(
      onListen: () {
        stream.listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () => controller.add(data));
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
        );
      },
      onCancel: () => timer?.cancel(),
    );

    return controller.stream;
  }
}
