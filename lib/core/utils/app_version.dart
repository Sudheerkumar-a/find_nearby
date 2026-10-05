abstract final class AppVersion {
  /// Compares semver-like strings (`1.2.3`). Returns negative if [a] < [b].
  static int compare(String a, String b) {
    final pa = _parts(a);
    final pb = _parts(b);
    final length = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < length; i++) {
      final da = i < pa.length ? pa[i] : 0;
      final db = i < pb.length ? pb[i] : 0;
      if (da != db) return da.compareTo(db);
    }
    return 0;
  }

  static bool isOlder(String current, String target) => compare(current, target) < 0;

  static List<int> _parts(String raw) {
    final cleaned = raw.split('+').first.trim();
    if (cleaned.isEmpty) return const [0];
    return cleaned
        .split('.')
        .map((part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
  }
}
