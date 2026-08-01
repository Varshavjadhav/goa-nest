abstract class SecureStorageService {
  Future<void> write(String key, dynamic value);
  Future<T?> read<T>(String key);
  Future<void> delete(String key);
  Future<Map<String, String>> readAll();
  Future<void> deleteAll();
  Future<bool> containsKey(String key);
  Future<void> saveLocale(String localeCode);
  Future<String?> getLocale();
  Future<void> writeIntList(String key, List<int> value);
  Future<List<int>?> readIntList(String key);
}
