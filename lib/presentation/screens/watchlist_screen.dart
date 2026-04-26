import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist_assignment/presentation/bloc/watchlist_bloc.dart';
import 'package:watchlist_assignment/presentation/widgets/bottom_nav_bar.dart';
import 'package:watchlist_assignment/presentation/widgets/index_tile.dart';
import 'package:watchlist_assignment/presentation/widgets/search_bar.dart';
import 'package:watchlist_assignment/presentation/widgets/stock_tile.dart';

import 'edit_watchlist_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) => switch (state) {
          WatchlistIdle() || WatchlistFetching() => const Center(
            child: CircularProgressIndicator(),
          ),
          WatchlistFailed(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(message),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.read<WatchlistBloc>().add(
                    const LoadWatchlists(),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          WatchlistLoaded() => WatchlistContent(state: state),
        },
      ),
    );
  }
}

class WatchlistContent extends StatelessWidget {
  final WatchlistLoaded state;

  const WatchlistContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _IndexHeader(),
        SearchBarWidget(),
        _TabStrip(state: state),
        Expanded(child: _StocksView(state: state)),
        const BottomNavBar(),
      ],
    );
  }
}

class _IndexHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: EdgeInsets.fromLTRB(16, 40, 16, 8),
      child: const Row(
        children: [
          Expanded(
            child: IndexTile(
              label: 'SENSEX 18TH SEP 8...',
              exchange: 'BSE',
              value: '1,225.55',
              change: '+144.50 (13.3...)',
              isPositive: true,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: IndexTile(
              label: 'NIFTY BANK',
              exchange: 'NSE',
              value: '54,170.15',
              change: '-16.75 (-0.03...)',
              isPositive: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabStrip extends StatelessWidget {
  final WatchlistLoaded state;

  const _TabStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.watchlists.length,
            separatorBuilder: (_, _) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              final selected = index == state.selectedTabIndex;
              return GestureDetector(
                onTap: () => context.read<WatchlistBloc>().add(
                  TabTapped(index),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      state.watchlists[index].name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  final bloc = context.read<WatchlistBloc>();
                  final s = bloc.state;
                  if (s is! WatchlistLoaded) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: bloc,
                        child: EditWatchlistScreen(
                          watchlist: s.currentList,
                        ),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.sort_rounded, size: 15),
                label: const Text('Sort by', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StocksView extends StatelessWidget {
  final WatchlistLoaded state;

  const _StocksView({required this.state});

  @override
  Widget build(BuildContext context) {
    final stocks = state.currentList.stocks;

    if (stocks.isEmpty) {
      return const Center(
        child: Text(
          'No stocks in this watchlist',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: stocks.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) => StockTile(stock: stocks[index]),
    );
  }
}
