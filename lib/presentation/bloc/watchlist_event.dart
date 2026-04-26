part of 'watchlist_bloc.dart';

sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

final class LoadWatchlists extends WatchlistEvent {
  const LoadWatchlists();
}

final class TabTapped extends WatchlistEvent {
  final int tabIndex;

  const TabTapped(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

final class StockDragged extends WatchlistEvent {
  final String watchlistId;
  final int oldIndex;
  final int newIndex;

  const StockDragged({
    required this.watchlistId,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [watchlistId, oldIndex, newIndex];
}

final class StockDeleted extends WatchlistEvent {
  final String watchlistId;
  final String symbol;
  final String exchange;

  const StockDeleted({
    required this.watchlistId,
    required this.symbol,
    required this.exchange,
  });

  @override
  List<Object?> get props => [watchlistId, symbol, exchange];
}

final class EditToggled extends WatchlistEvent {
  const EditToggled();
}
