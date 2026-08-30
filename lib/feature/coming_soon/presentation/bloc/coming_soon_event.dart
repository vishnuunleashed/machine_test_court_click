import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_event.dart';

abstract class ComingSoonEvent extends BaseBlocEvent {}

class FetchUpcomingMoviesEvent extends ComingSoonEvent {}

// Requested when the list is scrolled near its end, to append the next page.
class FetchNextUpcomingPageEvent extends ComingSoonEvent {}
