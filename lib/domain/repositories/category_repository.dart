import '../entities/app_category.dart';

abstract class CategoryRepository {
  Stream<List<AppCategory>> watchAll();

  Future<List<AppCategory>> getAll();

  Future<void> setEnabled(String categoryId, bool enabled);

  Future<void> reorder(List<String> orderedIds);

  Future<void> addCustom({
    required String name,
    required String query,
    String icon,
  });

  Future<void> removeCustom(String categoryId);

  Future<void> resetToDefaults();
}
