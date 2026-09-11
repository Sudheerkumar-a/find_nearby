import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesFilterController extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? value) => state = value;
}

final favoritesFilterProvider =
    NotifierProvider<FavoritesFilterController, String?>(
      FavoritesFilterController.new,
    );
