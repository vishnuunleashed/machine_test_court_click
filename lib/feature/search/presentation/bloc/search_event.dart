import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_event.dart';

abstract class SearchEvent extends BaseBlocEvent {}

class SearchQueryChanged extends SearchEvent {
  SearchQueryChanged(this.query);

  final String query;
}
