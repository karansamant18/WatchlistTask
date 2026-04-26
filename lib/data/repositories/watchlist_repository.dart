import '../models/stock_model.dart';
import '../models/watchlist_model.dart';

class WatchlistRepository {
  late List<WatchlistModel> _watchlists;

  WatchlistRepository() {
    _watchlists = _seedData();
  }

  Future<List<WatchlistModel>> loadAll() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_watchlists);
  }

  Future<WatchlistModel> saveNewOrder(
    String watchlistId,
    int oldIndex,
    int newIndex,
  ) async {
    final idx = _findIndex(watchlistId);
    final stocks = List<StockModel>.from(_watchlists[idx].stocks);

    final adjusted = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = stocks.removeAt(oldIndex);
    stocks.insert(adjusted, item);

    final updated = _watchlists[idx].copyWith(stocks: stocks);
    _watchlists = List<WatchlistModel>.from(_watchlists)..[idx] = updated;
    return updated;
  }

  Future<WatchlistModel> deleteStock(
    String watchlistId,
    String symbol,
    String exchange,
  ) async {
    final idx = _findIndex(watchlistId);
    final stocks = _watchlists[idx].stocks
        .where((s) => !(s.symbol == symbol && s.exchange == exchange))
        .toList();
    final updated = _watchlists[idx].copyWith(stocks: stocks);
    _watchlists = List<WatchlistModel>.from(_watchlists)..[idx] = updated;
    return updated;
  }

  int _findIndex(String id) {
    final idx = _watchlists.indexWhere((w) => w.id == id);
    if (idx == -1) throw ArgumentError('Watchlist not found: $id');
    return idx;
  }

  List<WatchlistModel> _seedData() => [
    WatchlistModel(
      id: 'wl_1',
      name: 'Watchlist 1',
      stocks: const [
        StockModel(
          symbol: 'RELIANCE',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 1374.10,
          change: -4.40,
          changePercent: -0.32,
        ),
        StockModel(
          symbol: 'HDFCBANK',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 966.85,
          change: 0.85,
          changePercent: 0.09,
        ),
        StockModel(
          symbol: 'ASIANPAINT',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 2537.40,
          change: 6.60,
          changePercent: 0.26,
        ),
        StockModel(
          symbol: 'NIFTY IT',
          exchange: 'NSE',
          type: StockType.idx,
          ltp: 35187.30,
          change: 876.86,
          changePercent: 2.56,
        ),
        StockModel(
          symbol: 'RELIANCE SEP 1880 CE',
          exchange: 'NSE',
          type: StockType.options,
          ltp: 0.00,
          change: 0.00,
          changePercent: 0.00,
        ),
        StockModel(
          symbol: 'RELIANCE SEP 1370 PE',
          exchange: 'NSE',
          type: StockType.options,
          ltp: 19.20,
          change: 1.00,
          changePercent: 5.49,
        ),
        StockModel(
          symbol: 'MRF',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 147625.00,
          change: 550.00,
          changePercent: 0.37,
        ),
        StockModel(
          symbol: 'MRF',
          exchange: 'BSE',
          type: StockType.equity,
          ltp: 147439.45,
          change: 463.80,
          changePercent: 0.32,
        ),
        StockModel(
          symbol: 'TCS',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 3541.20,
          change: -22.35,
          changePercent: -0.63,
        ),
        StockModel(
          symbol: 'INFY',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 1487.60,
          change: 18.90,
          changePercent: 1.29,
        ),
      ],
    ),
    WatchlistModel(
      id: 'wl_5',
      name: 'Watchlist 5',
      stocks: const [
        StockModel(
          symbol: 'NIFTY 50',
          exchange: 'NSE',
          type: StockType.idx,
          ltp: 22456.80,
          change: 134.50,
          changePercent: 0.60,
        ),
        StockModel(
          symbol: 'BAJFINANCE',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 6812.40,
          change: -45.20,
          changePercent: -0.66,
        ),
      ],
    ),
    WatchlistModel(
      id: 'wl_6',
      name: 'Watchlist 6',
      stocks: const [
        StockModel(
          symbol: 'SBIN',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 612.35,
          change: 8.75,
          changePercent: 1.45,
        ),
        StockModel(
          symbol: 'ICICIBANK',
          exchange: 'NSE',
          type: StockType.equity,
          ltp: 1023.90,
          change: -5.10,
          changePercent: -0.50,
        ),
      ],
    ),
  ];
}
