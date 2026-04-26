import 'package:equatable/equatable.dart';

import 'stock_model.dart';

class WatchlistModel extends Equatable {
  final String id;
  final String name;
  final List<StockModel> stocks;

  const WatchlistModel({
    required this.id,
    required this.name,
    required this.stocks,
  });

  WatchlistModel copyWith({
    String? id,
    String? name,
    List<StockModel>? stocks,
  }) => WatchlistModel(
    id: id ?? this.id,
    name: name ?? this.name,
    stocks: stocks ?? this.stocks,
  );

  @override
  List<Object?> get props => [id, name, stocks];
}
