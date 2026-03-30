# Currency Converter App

A Flutter currency converter assessment built with Clean Architecture, BLoC, and a local SQLite cache. The app fetches live exchange data, converts between currencies, and displays recent historical rates — all through a single, unified API provider.

---

## Features

- Browse supported currencies with their country flags
- Local caching: currencies are fetched from the API only on the first launch, then served from a local SQLite database
- Convert between any two currencies with live exchange rates
- Input validation and same-currency guard on the converter screen
- Historical exchange rates for the last 7 days (business days), shown in a clean list grouped by currency pair
- Three-tab navigation: Currencies, Converter, History
- Error states with retry actions on each screen

---

## Screens

| Screen | Description |
|--------|-------------|
| **Currencies** | Full list of supported currencies with flag, code, and full name |
| **Converter** | Amount input, source and target currency selectors, live conversion result |
| **History** | Exchange rate history for USD → EUR and USD → GBP over the last 7 days |

---

## Architecture

I structured the project around **Clean Architecture**, splitting code into three layers:

```
Presentation  →  Domain  →  Data
```

- **Presentation**: Flutter widgets, BLoC (events, states, bloc)
- **Domain**: Entities, repository interfaces, use cases — no framework dependencies
- **Data**: Remote data sources (Dio), local data sources (SQLite), models, repository implementations

The main benefit I wanted from this is that the domain layer stays completely isolated. Swapping a data source or changing the API doesn't ripple into the UI, and each layer can be tested on its own.

---

## Project Structure

```
lib/
├── app/
│   ├── app.dart
│   └── di/
│       └── injection.dart
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── database/
│   │   ├── app_database.dart
│   │   └── database_tables.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── dio_client.dart
│   └── utils/
│       └── currency_flag_mapper.dart
└── features/
    ├── currencies/
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    ├── converter/        # same sub-structure
    ├── history/          # same sub-structure
    └── home/
        └── presentation/
            └── pages/
                └── home_page.dart
```

---

## State Management

I used **BLoC (flutter_bloc)** for all three features. Each feature has its own isolated event, state, and bloc classes.

I find BLoC a good fit here because the state transitions are explicit and easy to follow during a review — you can read the events and states almost like a spec. It also aligns naturally with the clean architecture layers, since the BLoC sits in the presentation layer and only calls use cases.

Each BLoC is registered as a **Factory** in GetIt so that every screen gets a fresh instance.

---

## Dependency Injection

I used **get_it** for service location. All dependencies — core services, data sources, repositories, use cases, and BLoCs — are registered in a single `injection.dart` file under `lib/app/di/`.

Keeping everything in one place makes the wiring easy to audit. There's no scattered construction logic across widget trees.

---

## Networking

All HTTP calls go through **Dio**, wrapped in a `DioClient` that reads its base URL and timeouts from `ApiConstants`. I went with Dio mainly for its clean query parameter handling and the fact that it's well-established in Flutter projects.

---

## Local Database

I used **sqflite** for local caching. The currency list is saved to a local SQLite database on the first fetch. On every subsequent launch, the app reads from the database and skips the network call entirely.

This covers the assessment requirement of persisting data locally after the first API request.

---

## API Provider

The original assessment API endpoint was unavailable during development. I switched to the **[Frankfurter API](https://www.frankfurter.app/)**, which is free, requires no API key, and is backed by European Central Bank (ECB) reference rates.

| Endpoint | Purpose |
|----------|---------|
| `GET /currencies` | Fetch the list of supported currencies with full names |
| `GET /latest?from={base}&to={target}` | Fetch the current exchange rate for conversion |
| `GET /{start}..{end}?from={base}&to={targets}` | Fetch historical rates for a date range |

All three features — currencies, converter, and history — go through the same provider with no mixing.

---

## History Feature — Pairing Note

The assessment originally asked for historical data for **USD → EGP** and **USD → EUR**.

Frankfurter is sourced from ECB reference rates, and EGP (Egyptian Pound) is not among the currencies the ECB publishes. The history screen therefore uses:

- **USD → EUR**
- **USD → GBP**

Both are real ECB-published pairs. The data covers the last 7 calendar days, filtered to business days as the ECB only publishes on weekdays. This is an API constraint, not a design decision.

---

## Packages Used

| Package | Purpose |
|---------|---------|
| `dio` | HTTP networking |
| `get_it` | Dependency injection |
| `flutter_bloc` | BLoC state management |
| `equatable` | Value equality for BLoC states and entities |
| `sqflite` | Local SQLite database |
| `path` | Database path resolution |
| `flutter_svg` | Rendering country flag SVGs |

---

## How to Run

**Requirements:** Flutter SDK (stable channel), Dart SDK

```bash
# Get dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

No API key or environment configuration is required. The app works out of the box.

---

## Testing

I added a focused test suite covering the most important parts of the project — business logic, repository behavior, and BLoC state transitions. I kept it lean rather than aiming for exhaustive coverage at this stage.

| Test file | What it covers |
|-----------|----------------|
| `converter/domain/convert_currency_test.dart` | Use case delegates to the repository and returns the result |
| `currencies/data/currencies_repository_impl_test.dart` | Cache-first: returns local data when available; fetches and caches from remote when local is empty |
| `converter/presentation/bloc/converter_bloc_test.dart` | `Loading → Loaded` on success; `Loading → Error` on failure |
| `widget_test.dart` | App widget renders without crashing |

```bash
# Run all tests
flutter test
```

---

## Notes and Assumptions

- The currency list is cached after the first successful API response. Clearing the app data or reinstalling will trigger a fresh fetch.
- The history screen shows business days only, as that is what the ECB publishes. Weekends are not included in the response.
- The converter defaults to USD → EUR on first load. Both currencies are always available in Frankfurter.
- Country flags are resolved through a local mapper that covers all Frankfurter-supported currencies, with a two-character code fallback for any unmapped codes.

