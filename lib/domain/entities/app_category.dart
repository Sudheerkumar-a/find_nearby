import 'place_category.dart';

final class AppSubcategory {
  const AppSubcategory({
    required this.id,
    required this.name,
    this.placeCategory,
    this.searchQuery,
    this.icon,
  });

  final String id;
  final String name;

  /// Internal category — providers map from this only.
  final PlaceCategory? placeCategory;

  /// Fallback text for custom / unmapped searches.
  final String? searchQuery;
  final String? icon;

  String get query => searchQuery ?? name;
}

final class AppCategory {
  const AppCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.subcategories,
    this.group,
    this.enabled = true,
    this.sortOrder = 0,
    this.isCustom = false,
    this.customQuery,
  });

  final String id;
  final String name;
  final String icon;
  final List<AppSubcategory> subcategories;
  final PlaceCategoryGroup? group;
  final bool enabled;
  final int sortOrder;
  final bool isCustom;
  final String? customQuery;

  AppCategory copyWith({
    String? name,
    String? icon,
    List<AppSubcategory>? subcategories,
    PlaceCategoryGroup? group,
    bool? enabled,
    int? sortOrder,
    String? customQuery,
  }) {
    return AppCategory(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      subcategories: subcategories ?? this.subcategories,
      group: group ?? this.group,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
      isCustom: isCustom,
      customQuery: customQuery ?? this.customQuery,
    );
  }
}

final class QuickAction {
  const QuickAction({
    required this.id,
    required this.label,
    required this.icon,
    this.placeCategory,
    this.searchQuery,
    this.categoryId,
    this.subcategoryId,
  });

  final String id;
  final String label;
  final String icon;
  final PlaceCategory? placeCategory;
  final String? searchQuery;
  final String? categoryId;
  final String? subcategoryId;
}
