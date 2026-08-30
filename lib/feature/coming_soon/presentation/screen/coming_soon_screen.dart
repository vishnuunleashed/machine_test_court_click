import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_court_click/feature/coming_soon/presentation/bloc/coming_soon_bloc.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/utiiity/app_theme/app_theme.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/base_view.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';
import 'package:machine_test_court_click/utiiity/widgets/app_bottom_nav_bar.dart';
import 'package:machine_test_court_click/utiiity/widgets/shimmer_box.dart';

import '../bloc/coming_soon_event.dart';

// TMDB image base, see api docs: https://image.tmdb.org/t/p/w500<poster_path>
const _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

const _genreNames = {
  28: 'Action', 12: 'Adventure', 16: 'Animation', 35: 'Comedy', 80: 'Crime',
  99: 'Documentary', 18: 'Drama', 10751: 'Family', 14: 'Fantasy', 36: 'History',
  27: 'Horror', 10402: 'Music', 9648: 'Mystery', 10749: 'Romance',
  878: 'Sci-Fi', 10770: 'TV Movie', 53: 'Thriller', 10752: 'War', 37: 'Western',
};

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ComingSoonBloc, MoviesResponse>(
      // This screen shows its own shimmer skeleton for the first load.
      showLoadingOverlay: false,
      create: () => ComingSoonBloc()..add(FetchUpcomingMoviesEvent()),
      builder: (context, state) {
        final isFirstLoad = state.status == BaseStatus.loading && state.data == null;

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: isFirstLoad
                ? _buildShimmerBody()
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      final metrics = notification.metrics;
                      if (metrics.pixels > metrics.maxScrollExtent - 400) {
                        context.read<ComingSoonBloc>().add(FetchNextUpcomingPageEvent());
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: () => _onRefresh(context),
                      child: CustomScrollView(
                        slivers: _buildUpcomingSlivers(context, state),
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
        );
      },
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<ComingSoonBloc>();
    bloc.add(FetchUpcomingMoviesEvent());
    await bloc.stream.firstWhere((s) => s.status != BaseStatus.loading);
  }

  List<Widget> _buildUpcomingSlivers(BuildContext context, BaseBlocState<MoviesResponse> state) {
    if (state.status == BaseStatus.failure) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                state.exception?.message ?? 'Something went wrong',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ];
    }

    final movies = state.data?.results ?? const <MovieResult>[];
    if (movies.isEmpty) return const [];

    final hasMore = (state.data?.page ?? 1) < (state.data?.totalPages ?? 1);

    return [
      SliverList.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) => _buildUpcomingCard(context, movies[index]),
      ),
      if (hasMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
    ];
  }

  Widget _buildShimmerBody() {
    return ListView(
      padding: EdgeInsets.zero,
      children: const [
        ShimmerBox(height: 220, borderRadius: 0),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 160, height: 14),
              SizedBox(height: 12),
              ShimmerBox(width: 220, height: 20),
              SizedBox(height: 12),
              ShimmerBox(width: double.infinity, height: 14),
              SizedBox(height: 6),
              ShimmerBox(width: double.infinity, height: 14),
            ],
          ),
        ),
        ShimmerBox(height: 200, borderRadius: 0),
      ],
    );
  }

  Widget _buildUpcomingCard(BuildContext context, MovieResult movie) {
    final title = movie.title ?? movie.name ?? '';
    final backdrop = movie.backdropPath;
    final poster = movie.posterPath;
    final genres = movie.genreIds
        .map((id) => _genreNames[id])
        .whereType<String>()
        .take(4)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          fit: StackFit.passthrough,
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: backdrop != null
                  ? Image.network(
                      '$_imageBaseUrl$backdrop',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade900),
                    )
                  : Container(color: Colors.grey.shade900),
            ),
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppTheme.backgroundBlack.withValues(alpha: 0.85)],
                  stops: const [0.4, 1.0],
                ),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(letterSpacing: 4),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconAction(context, Icons.notifications_none, 'Remind Me'),
              const SizedBox(width: 48),
              _buildIconAction(context, Icons.share_outlined, 'Share'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_formatComingDate(movie.releaseDate), style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(movie.overview, style: Theme.of(context).textTheme.bodyMedium),
              if (genres.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  genres.join('  •  '),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: poster != null
              ? Image.network(
                  '$_imageBaseUrl$poster',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade800),
                )
              : Container(color: Colors.grey.shade800),
        ),
      ],
    );
  }

  String _formatComingDate(String? releaseDate) {
    final date = releaseDate == null ? null : DateTime.tryParse(releaseDate);
    if (date == null) return 'Coming soon';
    return 'Coming ${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildIconAction(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
