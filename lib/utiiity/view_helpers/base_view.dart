import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';

class BaseView<B extends StateStreamableSource<BaseBlocState<T>>, T>
    extends StatelessWidget {
  const BaseView({
    super.key,
    required this.create,
    required this.builder,
    this.showLoadingOverlay = true,
  });

  final B Function() create;
  final Widget Function(BuildContext context, BaseBlocState<T> state) builder;

  // Screens that render their own loading UI (e.g. shimmer skeletons) can
  // set this to false to avoid stacking a spinner on top of it.
  final bool showLoadingOverlay;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (_) => create(),
      child: BlocListener<B, BaseBlocState<T>>(
        listenWhen: (previous, current) {
          return previous.status != current.status &&
              current.status == BaseStatus.failure &&
              current.exception != null;
        },
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.exception!.message)),
          );
        },
        child: Builder(
          builder: (context) {
            final state = context.select<B, BaseBlocState<T>>((bloc) => bloc.state);
            return Stack(
              alignment: Alignment.center,
              children: [
                builder(context, state),
                if (showLoadingOverlay && state.status == BaseStatus.loading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.1),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
