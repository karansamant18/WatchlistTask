import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist_assignment/presentation/bloc/watchlist_bloc.dart';
import 'package:watchlist_assignment/presentation/widgets/stock_tile.dart';

import '../../../data/models/watchlist_model.dart';

class EditWatchlistScreen extends StatelessWidget {
  final WatchlistModel watchlist;

  const EditWatchlistScreen({super.key, required this.watchlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${watchlist.name}')),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is! WatchlistLoaded) return const SizedBox.shrink();

          final active = state.watchlists.firstWhere(
            (w) => w.id == watchlist.id,
          );

          return Column(
            children: [
              ListTile(
                title: Text(
                  active.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.edit_outlined),
                tileColor: Colors.grey.shade100,
              ),
              const Divider(height: 1),
              Expanded(
                child: ReorderableListView.builder(
                  padding: EdgeInsets.zero,
                  buildDefaultDragHandles: false,
                  proxyDecorator: _dragDecoration,
                  onReorder: (oldIndex, newIndex) {
                    HapticFeedback.selectionClick();
                    context.read<WatchlistBloc>().add(
                      StockDragged(
                        watchlistId: watchlist.id,
                        oldIndex: oldIndex,
                        newIndex: newIndex,
                      ),
                    );
                  },
                  itemCount: active.stocks.length,
                  itemBuilder: (context, index) {
                    final stock = active.stocks[index];
                    return ReorderableDragStartListener(
                      key: ValueKey('${stock.symbol}_${stock.exchange}'),
                      index: index,
                      child: Column(
                        children: [
                          StockTile(
                            stock: stock,
                            isEditMode: true,
                            onDelete: () {
                              HapticFeedback.lightImpact();
                              context.read<WatchlistBloc>().add(
                                StockDeleted(
                                  watchlistId: watchlist.id,
                                  symbol: stock.symbol,
                                  exchange: stock.exchange,
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _SaveBar(onSave: () => Navigator.of(context).pop()),
            ],
          );
        },
      ),
    );
  }

  Widget _dragDecoration(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (_, child) => Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  final VoidCallback onSave;

  const _SaveBar({required this.onSave});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom),
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Edit other watchlists'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save Watchlist'),
          ),
        ],
      ),
    );
  }
}
