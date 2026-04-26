import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/watchlist_model.dart';
import '../../data/repositories/watchlist_repository.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository _repository;

  WatchlistBloc(this._repository) : super(const WatchlistIdle()) {
    on<LoadWatchlists>(_fetchWatchlists);
    on<TabTapped>(_switchTab);
    on<StockDragged>(_moveStock);
    on<StockDeleted>(_deleteStock);
    on<EditToggled>(_toggleEditMode);
  }

  Future<void> _fetchWatchlists(
    LoadWatchlists event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(const WatchlistFetching());
    try {
      final watchlists = await _repository.loadAll();
      emit(WatchlistLoaded(watchlists: watchlists));
    } catch (e) {
      emit(WatchlistFailed(e.toString()));
    }
  }

  void _switchTab(TabTapped event, Emitter<WatchlistState> emit) {
    final current = state;
    if (current is! WatchlistLoaded) return;
    emit(current.copyWith(selectedTabIndex: event.tabIndex, isEditMode: false));
  }

  Future<void> _moveStock(
    StockDragged event,
    Emitter<WatchlistState> emit,
  ) async {
    final current = state;
    if (current is! WatchlistLoaded) return;

    final optimistic = _shiftStockLocally(
      current.watchlists,
      event.watchlistId,
      event.oldIndex,
      event.newIndex,
    );
    emit(current.copyWith(watchlists: optimistic));

    try {
      final updated = await _repository.saveNewOrder(
        event.watchlistId,
        event.oldIndex,
        event.newIndex,
      );
      emit(current.copyWith(watchlists: _replaceWatchlist(current.watchlists, updated)));
    } catch (_) {
      emit(current);
    }
  }

  Future<void> _deleteStock(
    StockDeleted event,
    Emitter<WatchlistState> emit,
  ) async {
    final current = state;
    if (current is! WatchlistLoaded) return;
    try {
      final updated = await _repository.deleteStock(
        event.watchlistId,
        event.symbol,
        event.exchange,
      );
      emit(current.copyWith(watchlists: _replaceWatchlist(current.watchlists, updated)));
    } catch (e) {
      emit(WatchlistFailed(e.toString()));
    }
  }

  void _toggleEditMode(
    EditToggled event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoaded) return;
    emit(current.copyWith(isEditMode: !current.isEditMode));
  }

  List<WatchlistModel> _shiftStockLocally(
    List<WatchlistModel> watchlists,
    String watchlistId,
    int oldIndex,
    int newIndex,
  ) {
    return watchlists.map((wl) {
      if (wl.id != watchlistId) return wl;
      final stocks = List.of(wl.stocks);
      final adjusted = newIndex > oldIndex ? newIndex - 1 : newIndex;
      final item = stocks.removeAt(oldIndex);
      stocks.insert(adjusted, item);
      return wl.copyWith(stocks: stocks);
    }).toList();
  }

  List<WatchlistModel> _replaceWatchlist(
    List<WatchlistModel> watchlists,
    WatchlistModel updated,
  ) => watchlists.map((wl) => wl.id == updated.id ? updated : wl).toList();
}
