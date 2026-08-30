# Court Click Movies

A Netflix-styled movie discovery app built in Flutter on top of [TMDB](https://www.themoviedb.org/)'s API.

The basic architecture, layering and core logic (BLoC wiring, API layer, DI setup, screen composition) in this project were designed and hand-written from scratch to a Figma reference, rather than pulled from a template or boilerplate generator.

## Screens

1. Splash
2. Profile Select ("Who's watching")
3. Home
4. Search
5. Coming Soon
6. Downloads
7. More

## APK

A prebuilt release APK is included at [`release/court-click-movies.apk`](release/court-click-movies.apk) — install it directly on any Android device.

## Setup

1. Install Flutter (this project targets Dart SDK `^3.8.1`).
2. `flutter pub get`
3. Add your TMDB API key — see below.
4. Run: `flutter run`

### Adding your API key

The app reads credentials from `assets/.env` (already listed as a Flutter asset in `pubspec.yaml`, and git-ignored so real keys never get committed). Copy the template and fill in your own values:

```
cp assets/.env.example assets/.env
```

```
base_url=https://api.themoviedb.org/3
api_key=<your TMDB v3 API key>
api_read_access_token=<your TMDB v4 read access token>
```

Get both from your TMDB account under **Settings → API**. The HTTP layer (`BaseHttp`) prefers the v4 Bearer token when present and only falls back to the `api_key` query param otherwise, matching TMDB's "use either" auth rule.

## Architecture

Feature-first, with a light Clean-Architecture-style split per feature:

```
lib/
  feature/
    <feature>/
      domain/        // repository interface + use case
      data/           // repository implementation (Dio calls, JSON parsing)
      presentation/
        bloc/         // event, state, bloc
        screen/       // widgets
  utiiity/
    helpers/          // BaseHttp (Dio wrapper), AppException
    view_helpers/     // BaseBloc, BaseBlocState, BaseView
    router/           // go_router routes
    widgets/          // shared widgets (bottom nav, shimmer box)
    app_theme/        // ThemeData
    get_it_locator.dart
```

Key pieces:

- **BaseHttp** — a small Dio wrapper (`utiiity/helpers/base_http_using_dio_with_error_handling.dart`) that centralizes the base URL, auth headers, and error mapping into `AppException` subtypes (timeout, unauthorized, invalid request, server error).
- **BaseBloc<Event, T> / BaseBlocState<T>** — a generic base class every feature's bloc extends, so each bloc only writes its own event handlers and calls `baseMethod(emit, apiCall)`, which handles the loading → success/failure state transitions consistently.
- **BaseView<Bloc, T>** — wraps a screen in its `BlocProvider`, shows a snackbar on failure, and overlays a spinner while loading (a screen can opt out via `showLoadingOverlay: false` if it renders its own shimmer skeleton instead).
- **get_it** — a single `sl` (service locator) instance wires repository implementations and use cases; blocs pull their use case from `sl` in their constructor.
- **go_router** — all navigation, including the bottom navigation bar, goes through named routes; page transitions use a shared fade transition.

## API-driven vs. static screens

| Screen | Data source |
|---|---|
| Home | Live — `/trending/all/week`, `/movie/popular`, `/movie/now_playing`, `/movie/top_rated` |
| Search | Live — `/search/movie`, debounced ~400ms |
| Coming Soon | Live — `/movie/upcoming`, with pagination |
| Splash | Static |
| Profile Select | Static (hardcoded profiles — no auth/profile API was in scope) |
| Downloads | Static (no downloads API was in scope) |
| More | Static (profile list, settings links — no account API was in scope) |

## Bonus items included

- **Pagination / infinite scroll** — Coming Soon appends the next TMDB page as you scroll near the bottom, instead of replacing the list.
- **Pull-to-refresh** — Home and Coming Soon.
- **Shimmer loading placeholders** — Home and Coming Soon show skeleton content on first load instead of a bare spinner (`shimmer` package).
- **Unit tests** — `test/feature/coming_soon/coming_soon_bloc_test.dart` covers `ComingSoonBloc`'s success, failure, and pagination-append behavior using `bloc_test` + `mocktail`.
- **Light & dark theme** — both `ThemeData`s are defined in `AppTheme`; the app defaults to dark (matching the Netflix-style design the screens were built against), see *Assumptions* below.
- **Dependency injection** — `get_it`, one `sl` instance, registered in `get_it_locator.dart`.
- **Smooth page transitions** — fade transition shared by every route in `app_routers.dart`.

Not attempted: Hero animations (there's no detail screen in scope to animate into, so there was nothing meaningful to hero between).

## Assumptions

Requirements not fully specified in the brief were resolved as follows:

- **Profile/auth**: no login or profile API was given, so the profile-select screen uses four hardcoded profiles and simply routes to Home on tap.
- **Downloads / More**: no APIs were given for these, so both screens are static UI matching the reference designs.
- **Coming Soon "notifications"**: the reference design showed a "New Arrival" notifications panel with no backing API in scope, so it was left out rather than filled with fabricated data.
- **Coming Soon genres**: `/movie/upcoming` returns TMDB genre IDs, not names; a small local ID→name lookup table is used for the tag row instead of an extra `/genre/movie/list` call.
- **Theme default**: the app forces `ThemeMode.dark` since every screen was designed against the dark Netflix-style palette; a `lightTheme` exists in code but isn't the active default.
- **App icon**: the provided `logos_netflix-icon.svg` is used as the Android adaptive icon (`android/app/src/main/res/mipmap-anydpi-v26`), hand-translated into a vector drawable since no SVG rasterizer was available in the dev environment; the legacy pre-Android-8 PNG fallback icons are unchanged.

## Packages used

| Package | Purpose |
|---|---|
| `dio` | HTTP client |
| `flutter_dotenv` | Loads API credentials from `assets/.env` |
| `flutter_bloc` | State management |
| `fpdart` | `Either` for repository error handling |
| `go_router` | Navigation |
| `get_it` | Dependency injection |
| `flutter_svg` | Renders the Netflix icon asset |
| `shimmer` | Skeleton loading placeholders |
| `bloc_test`, `mocktail` (dev) | Bloc unit testing |
| `flutter_lints` (dev) | Lint rules |
