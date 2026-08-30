import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/feature/home/presentation/bloc/home_bloc.dart';
import 'package:machine_test_court_click/feature/home/presentation/bloc/home_event.dart';
import 'package:machine_test_court_click/feature/home/presentation/bloc/home_state.dart';
import 'package:machine_test_court_click/utiiity/app_theme/app_theme.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/base_view.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';
import 'package:machine_test_court_click/utiiity/widgets/app_bottom_nav_bar.dart';
import 'package:machine_test_court_click/utiiity/widgets/shimmer_box.dart';

// TMDB image base, see api docs: https://image.tmdb.org/t/p/w500<poster_path>
const _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeBloc, HomeState>(
      // Home shows its own shimmer skeleton while loading instead of the
      // default spinner overlay.
      showLoadingOverlay: false,
      create: () => HomeBloc()
        ..add(FetchTrendingAllWeekEvent())
        ..add(FetchPopularMoviesEvent())
        ..add(FetchNowPlayingMoviesEvent())
        ..add(FetchTopRatedMoviesEvent()),
      builder: (context, state) {
        final data = state.data ?? const HomeState();
        final isFirstLoad = state.status == BaseStatus.loading && state.data == null;

        return _HomeBody(
          isLoading: isFirstLoad,
          trending: data.trendingAllWeek?.results ?? const <MovieResult>[],
          popular: data.popularMovies?.results ?? const <MovieResult>[],
          nowPlaying: data.nowPlayingMovies?.results ?? const <MovieResult>[],
          topRated: data.topRatedMovies?.results ?? const <MovieResult>[],
        );
      },
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody({
    required this.isLoading,
    required this.trending,
    required this.popular,
    required this.nowPlaying,
    required this.topRated,
  });

  final bool isLoading;
  final List<MovieResult> trending;
  final List<MovieResult> popular;
  final List<MovieResult> nowPlaying;
  final List<MovieResult> topRated;

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  // Height at which the banner has scrolled fully behind the pinned app bar.
  static const _collapseOffset = 380.0;

  final _scrollController = ScrollController();
  bool _appBarSolid = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final solid = _scrollController.offset > _collapseOffset;
    if (solid != _appBarSolid) {
      setState(() => _appBarSolid = solid);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<HomeBloc>();
    bloc.add(FetchTrendingAllWeekEvent());
    bloc.add(FetchPopularMoviesEvent());
    bloc.add(FetchNowPlayingMoviesEvent());
    bloc.add(FetchTopRatedMoviesEvent());
    await bloc.stream.firstWhere((s) => s.status != BaseStatus.loading);
  }

  @override
  Widget build(BuildContext context) {
    final featured = widget.trending.isNotEmpty ? widget.trending.first : null;

    return Scaffold(
      body: widget.isLoading
          ? _buildShimmerBody()
          : RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    stretch: true,
                    expandedHeight: 460,
                    backgroundColor: _appBarSolid ? AppTheme.backgroundBlack : Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    titleSpacing: 16,
                    title: _buildTopNavRow(context),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      background: _buildBannerBackground(context, featured),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: _buildPreviews(context, widget.trending)),
                  SliverToBoxAdapter(child: _buildMovieRow(context, 'Popular on Netflix', widget.popular)),
                  SliverToBoxAdapter(child: _buildMovieRow(context, 'Trending Now', widget.trending)),
                  SliverToBoxAdapter(child: _buildMovieRow(context, 'Top Rated', widget.topRated)),
                  SliverToBoxAdapter(child: _buildMovieRow(context, 'Now Playing', widget.nowPlaying)),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildShimmerBody() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const ShimmerBox(height: 460, borderRadius: 0),
        const SizedBox(height: 20),
        _buildShimmerRow(),
        _buildShimmerRow(),
        _buildShimmerRow(),
      ],
    );
  }

  Widget _buildShimmerRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShimmerBox(width: 140, height: 18),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, __) => const ShimmerBox(width: 105, height: 150),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavRow(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/icons/logos_netflix-icon.svg', width: 22),
        const SizedBox(width: 20),
        Text('TV Shows', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(width: 16),
        Text('Movies', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(width: 16),
        Text('My List', style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        const Icon(Icons.search, color: Colors.white),
      ],
    );
  }

  Widget _buildBannerBackground(BuildContext context, MovieResult? movie) {
    final backdrop = movie?.backdropPath;
    final title = movie?.title ?? movie?.name ?? '';

    return Stack(
      fit: StackFit.expand,
      children: [
        if (backdrop != null)
          Image.network(
            '$_imageBaseUrl$backdrop',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade900),
          )
        else
          Container(color: Colors.grey.shade900),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppTheme.backgroundBlack.withValues(alpha: 0.9),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBannerAction(context, Icons.add, 'My List'),
                  _buildBannerAction(context, Icons.play_arrow, 'Play', filled: true),
                  _buildBannerAction(context, Icons.info_outline, 'Info'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerAction(BuildContext context, IconData icon, String label, {bool filled = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: filled ? Colors.white : Colors.black.withValues(alpha: 0.4),
          child: Icon(icon, color: filled ? Colors.black : Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildPreviews(BuildContext context, List<MovieResult> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Previews', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final poster = movies[index].posterPath;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipOval(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: poster != null
                        ? Image.network(
                            '$_imageBaseUrl$poster',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade800),
                          )
                        : Container(color: Colors.grey.shade800),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieRow(BuildContext context, String title, List<MovieResult> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final poster = movies[index].posterPath;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: 105,
                      height: 150,
                      child: poster != null
                          ? Image.network(
                              '$_imageBaseUrl$poster',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade800),
                            )
                          : Container(color: Colors.grey.shade800),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
