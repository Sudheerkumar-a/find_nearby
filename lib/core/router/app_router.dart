import 'package:go_router/go_router.dart';

import '../../features/categories/presentation/manage_categories_screen.dart';
import '../../features/explore/presentation/explore_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/filters/presentation/filter_bottom_sheet.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/places/presentation/place_details_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/app_shell.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const favorites = '/favorites';
  static const explore = '/explore';
  static const settings = '/settings';
  static const search = '/search';
  static const filters = '/filters';
  static const manageCategories = '/manage-categories';
  static const map = '/map';

  static String place(String placeId) =>
      '/place/${Uri.encodeComponent(placeId)}';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              name: 'favorites',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: FavoritesScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              name: 'explore',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ExploreScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              name: 'settings',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/place/:placeId',
      name: 'place',
      builder: (context, state) {
        final raw = state.pathParameters['placeId'] ?? '';
        return PlaceDetailsScreen(placeId: Uri.decodeComponent(raw));
      },
    ),
    GoRoute(
      path: AppRoutes.search,
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.filters,
      name: 'filters',
      builder: (context, state) => const FilterPage(),
    ),
    GoRoute(
      path: AppRoutes.manageCategories,
      name: 'manage-categories',
      builder: (context, state) => const ManageCategoriesScreen(),
    ),
    GoRoute(
      path: AppRoutes.map,
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
  ],
);
