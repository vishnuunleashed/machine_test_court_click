import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_court_click/feature/home/data/models/movie_response_model.dart';
import 'package:machine_test_court_click/utiiity/app_theme/app_theme.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/base_view.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';
import 'package:machine_test_court_click/utiiity/widgets/app_bottom_nav_bar.dart';

import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';

// TMDB image base, see api docs: https://image.tmdb.org/t/p/w500<poster_path>
const _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<SearchBloc, MoviesResponse>(
      create: () => SearchBloc(),
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildSearchField(context)),
                ..._buildResultSlivers(context, state),
              ],
            ),
          ),
          bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
        );
      },
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          onChanged: (query) => context.read<SearchBloc>().add(SearchQueryChanged(query)),
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white70),
            suffixIcon: Icon(Icons.mic_none, color: Colors.white70),
            hintText: 'Search for a show, movie, genre, e.t.c.',
            hintStyle: TextStyle(color: Colors.white54),
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResultSlivers(BuildContext context, BaseBlocState<MoviesResponse> state) {
    switch (state.status) {
      case BaseStatus.loading:
        // BaseView already overlays a spinner for BaseStatus.loading.
        return const [];
      case BaseStatus.failure:
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
      case BaseStatus.success:
        final results = state.data?.results ?? const <MovieResult>[];
        if (results.isEmpty) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text('No results', style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ),
          ];
        }
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text('Top Searches', style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          SliverList.builder(
            itemCount: results.length,
            itemBuilder: (context, index) => _buildResultRow(context, results[index]),
          ),
        ];
      case BaseStatus.initial:
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'Start typing to search',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ];
    }
  }

  Widget _buildResultRow(BuildContext context, MovieResult movie) {
    final poster = movie.posterPath;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: const Color(0xFF2A2A2A),
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 100,
                height: 72,
                child: poster != null
                    ? Image.network(
                        '$_imageBaseUrl$poster',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade800),
                      )
                    : Container(color: Colors.grey.shade800),
              ),
              Positioned(
                left: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  color: AppTheme.primary,
                  child: const Text(
                    'N',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                movie.title ?? movie.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
