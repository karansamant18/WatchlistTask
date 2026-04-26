import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist_assignment/data/repositories/watchlist_repository.dart';
import 'package:watchlist_assignment/presentation/screens/watchlist_screen.dart';

import 'presentation/bloc/watchlist_bloc.dart';

void main() {
  runApp(const TradingApp());
}

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) =>
            WatchlistBloc(WatchlistRepository())..add(const LoadWatchlists()),
        child: const WatchlistScreen(),
      ),
    );
  }
}
