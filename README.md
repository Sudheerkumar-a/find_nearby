# FindNearby

**Find what you need, nearby.**

A Flutter app for local discovery. Search or pick a category, filter, then call or get directions. It is not a Google Maps clone.

| | |
| --- | --- |
| Flutter | 3.44.3 |
| Dart | 3.12.2 |
| UI | Material 3 |
| State | Riverpod 3 |
| Navigation | GoRouter |
| Local DB | Drift |
| Places | Google Places API (New) + Geoapify Places (hybrid), mock for UI work |

## Run

```bash
flutter pub get
dart run build_runner build
flutter run
```

The default place provider is **mock**. No API key is required to develop the UI.

## Environment

1. Copy `.env.example` to `.env`
2. Keep `PLACE_PROVIDER=mock` until API keys are ready
3. Never commit `.env`

`PLACE_PROVIDER` values:

| Value | Behavior |
| --- | --- |
| `mock` | Local fixtures only |
| `google` | Google Places only |
| `geoapify` | Geoapify only |
| `automatic` / `hybrid` | Parallel Google + Geoapify, then dedupe + rank |

You can also change the mode at runtime in **Settings → Place Data Provider**.

Compile-time defines also work:

```bash
flutter run --dart-define=PLACE_PROVIDER=automatic --dart-define=GOOGLE_PLACES_API_KEY=YOUR_KEY --dart-define=GEOAPIFY_API_KEY=YOUR_KEY
```

## Google Cloud setup

1. Create a Google Cloud project and enable **billing**
2. Enable APIs:
   - **Places API (New)**
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geocoding API** (optional, for reverse-geocoded labels)
3. Create two restricted keys:
   - **Places key** — Places API (New) only, Android package / iOS bundle restricted
   - **Maps key** — Maps SDK for Android / iOS only
4. Put the Places key in `.env` as `GOOGLE_PLACES_API_KEY`
5. Put the Maps key in Android `local.properties`:

```properties
GOOGLE_MAPS_API_KEY=your_maps_key
```

Then reference it from Gradle (already wired as `manifestPlaceholders["GOOGLE_MAPS_API_KEY"]`).

6. For iOS, add the Maps key in `ios/Runner/AppDelegate.swift` with `GMSServices.provideAPIKey` when you enable the maps plugin, or via an xcconfig that is **not** committed.

7. Example hybrid `.env`:

```env
PLACE_PROVIDER=automatic
GOOGLE_PLACES_API_KEY=your_places_key
GEOAPIFY_API_KEY=your_geoapify_key
```

If a selected provider’s key is missing, FindNearby falls back to the other provider or to mock.

## Geoapify setup

1. Create an account at [Geoapify](https://www.geoapify.com/)
2. Open the [My Projects](https://myprojects.geoapify.com/) dashboard
3. Create an API key
4. Restrict the key per Geoapify’s current guidance (HTTP referrers / IP / etc.)
5. Add it to `.env`:

```env
GEOAPIFY_API_KEY=your_key_here
```

Official docs: https://apidocs.geoapify.com/

FindNearby uses:

- [Places API](https://apidocs.geoapify.com/docs/places/) for nearby / name search
- [Place Details API](https://apidocs.geoapify.com/docs/place-details/) when opening a Geoapify place

A mobile app cannot fully hide API keys — restrict keys on the provider side.

## Android

- Application id: `com.find.nearby.find_nearby`
- Location permissions are declared in `AndroidManifest.xml`
- Maps key placeholder: `${GOOGLE_MAPS_API_KEY}`
- Set `GOOGLE_MAPS_API_KEY` in `android/local.properties` or as a Gradle property

## iOS

- Display name: Find Nearby
- Location usage strings are in `Info.plist`
- Query schemes: `tel`, `https`, `http`, `comgooglemaps`

## Test

```bash
dart format .
flutter analyze
flutter test
```

## Release

```bash
flutter build apk
flutter build appbundle
```

Do not ship an unrestricted API key. Restrict by API, package name / bundle id, and SHA-1.

## Architecture

UI depends on `PlaceRepository`, not a specific vendor. Riverpod selects:

- `MockPlaceRepository` — realistic fixtures
- `GooglePlacesRepository` — Nearby Search, Text Search, Place Details, field masks
- `GeoapifyPlaceRepository` — Places + Place Details
- `HybridPlaceRepository` — parallel providers → dedupe → rank

Local Drift tables store only user data: favorites snapshot (with `provider` + `providerPlaceId`), search history, category preferences, settings. Search results are not persisted.

## Product path

Open app → location → search or category → filter → place → Call / Directions / Website
