import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_event.dart';

abstract class HomeEvent extends BaseBlocEvent {}

class FetchTrendingAllWeekEvent extends HomeEvent {}

class FetchPopularMoviesEvent extends HomeEvent {}

class FetchNowPlayingMoviesEvent extends HomeEvent {}

class FetchTopRatedMoviesEvent extends HomeEvent {}