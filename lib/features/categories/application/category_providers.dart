import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/category_catalog.dart';
import '../../../core/di/providers.dart';
import '../../../domain/entities/app_category.dart';

final categoriesProvider = StreamProvider<List<AppCategory>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});

final enabledCategoriesProvider = Provider<List<AppCategory>>((ref) {
  final async = ref.watch(categoriesProvider);
  final list = async.value ?? CategoryCatalog.defaults;
  return list.where((category) => category.enabled).toList();
});
