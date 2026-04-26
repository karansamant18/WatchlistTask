import 'package:equatable/equatable.dart';

enum StockType { equity, idx, futures, options }

extension StockTypeLabel on StockType {
  String get label => switch (this) {
    StockType.equity => 'EQ',
    StockType.idx => 'IDX',
    StockType.futures => 'FUT',
    StockType.options => 'OPT',
  };
}

class StockModel extends Equatable {
  final String symbol;
  final String exchange;
  final StockType type;
  final double ltp;
  final double change;
  final double changePercent;

  const StockModel({
    required this.symbol,
    required this.exchange,
    required this.type,
    required this.ltp,
    required this.change,
    required this.changePercent,
  });

  bool get isGaining => change >= 0;
  bool get isFlat => change == 0 && changePercent == 0;

  StockModel copyWith({
    String? symbol,
    String? exchange,
    StockType? type,
    double? ltp,
    double? change,
    double? changePercent,
  }) => StockModel(
    symbol: symbol ?? this.symbol,
    exchange: exchange ?? this.exchange,
    type: type ?? this.type,
    ltp: ltp ?? this.ltp,
    change: change ?? this.change,
    changePercent: changePercent ?? this.changePercent,
  );

  @override
  List<Object?> get props => [
    symbol,
    exchange,
    type,
    ltp,
    change,
    changePercent,
  ];
}
