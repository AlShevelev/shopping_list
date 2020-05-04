abstract class DataStorage {
  // ignore: missing_return
  Future<List<String>> loadStringsList(String key);

  Future<void> saveStringsList(String key, List<String> list);
}