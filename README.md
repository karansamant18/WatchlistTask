# Watchlist Task

A Flutter app implementing a stock watchlist with drag-to-reorder functionality using BLoC state management.

## Approach

MVVM folder structure with BLoC as the ViewModel layer. The repository is instantiated directly in `main.dart` and passed into the BLoC constructor. Sample watchlist data lives in the repository as an in-memory store.

Reordering uses optimistic UI — the list updates instantly on drag drop without waiting for the repository, and rolls back if the operation fails.

## Project Structure

The project is split into two layers — `data` and `presentation`.

The data layer contains the models (`StockModel`, `WatchlistModel`) and the repository which holds the in-memory watchlist data and handles reorder and delete operations.

The presentation layer is split into viewmodels (the BLoC — events, states, and handlers), views (the watchlist screen and edit screen), and widgets (the reusable stock tile).

## BLoC Events

| Event | Description |
|---|---|
| `WatchlistStarted` | Initial data load on app launch |
| `WatchlistTabChanged` | Switches active watchlist tab |
| `WatchlistStockReordered` | Reorders a stock via drag and drop |
| `WatchlistStockRemoved` | Deletes a stock from the watchlist |

## Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc` | BLoC state management |
| `equatable` | Value equality for models and states |
| `bloc_test` | Unit testing BLoC |
| `mocktail` | Mocking repository in tests |

## Running the App

```bash
flutter pub get
flutter run
```

## Running Tests

```bash
flutter test
```
