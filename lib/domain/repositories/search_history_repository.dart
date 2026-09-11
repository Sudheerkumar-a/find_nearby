abstract class SearchHistoryRepository {
  Stream<List<String>> watchRecent();

  Future<List<String>> getRecent();

  Future<void> add(String query);

  Future<void> remove(String query);

  Future<void> clear();
}
