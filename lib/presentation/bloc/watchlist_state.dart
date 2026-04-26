part of 'watchlist_bloc.dart';

sealed class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

final class WatchlistIdle extends WatchlistState {
  const WatchlistIdle();
}

final class WatchlistFetching extends WatchlistState {
  const WatchlistFetching();
}

final class WatchlistLoaded extends WatchlistState {
  final List<WatchlistModel> watchlists;
  final int selectedTabIndex;
  final bool isEditMode;

  const WatchlistLoaded({
    required this.watchlists,
    this.selectedTabIndex = 0,
    this.isEditMode = false,
  });

  WatchlistModel get currentList => watchlists[selectedTabIndex];

  WatchlistLoaded copyWith({
    List<WatchlistModel>? watchlists,
    int? selectedTabIndex,
    bool? isEditMode,
  }) => WatchlistLoaded(
    watchlists: watchlists ?? this.watchlists,
    selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    isEditMode: isEditMode ?? this.isEditMode,
  );

  @override
  List<Object?> get props => [watchlists, selectedTabIndex, isEditMode];
}

final class WatchlistFailed extends WatchlistState {
  final String message;

  const WatchlistFailed(this.message);

  @override
  List<Object?> get props => [message];
}
