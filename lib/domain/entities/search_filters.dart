import '../../core/constants/app_constants.dart';

enum SortOption { nearest, highestRated, mostPopular }

final class SearchFilters {
  const SearchFilters({
    this.radiusMeters = AppConstants.defaultRadiusMeters,
    this.minRating,
    this.openNow = false,
    this.categoryId,
    this.subcategoryId,
    this.sort = SortOption.nearest,
    this.customRadius = false,
  });

  final double radiusMeters;
  final double? minRating;
  final bool openNow;
  final String? categoryId;
  final String? subcategoryId;
  final SortOption sort;
  final bool customRadius;

  int get activeCount {
    var count = 0;
    if (radiusMeters != AppConstants.defaultRadiusMeters || customRadius) {
      count++;
    }
    if (minRating != null) count++;
    if (openNow) count++;
    if (categoryId != null) count++;
    if (subcategoryId != null) count++;
    if (sort != SortOption.nearest) count++;
    return count;
  }

  SearchFilters copyWith({
    double? radiusMeters,
    double? minRating,
    bool clearMinRating = false,
    bool? openNow,
    String? categoryId,
    String? subcategoryId,
    bool clearCategory = false,
    bool clearSubcategory = false,
    SortOption? sort,
    bool? customRadius,
  }) {
    return SearchFilters(
      radiusMeters: radiusMeters ?? this.radiusMeters,
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      openNow: openNow ?? this.openNow,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      subcategoryId: clearSubcategory
          ? null
          : (subcategoryId ?? this.subcategoryId),
      sort: sort ?? this.sort,
      customRadius: customRadius ?? this.customRadius,
    );
  }

  SearchFilters reset() => const SearchFilters();
}
