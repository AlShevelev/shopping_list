part of data_storage;

class SharedPreferencesDataStorage implements DataStorage {
  @override
  Future<List<String>> loadStringsList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  @override
  Future<void> saveStringsList(String key, List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, list);
  }
}