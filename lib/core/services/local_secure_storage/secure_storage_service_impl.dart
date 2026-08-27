import 'package:goanest/core/services/local_secure_storage/secure_storage_service.dart';

import '../../../core.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  static final SecureStorageServiceImpl _instance = SecureStorageServiceImpl._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SecureStorageServiceImpl._internal();

  factory SecureStorageServiceImpl() => _instance;

  @override
  Future<void> write(String key, dynamic value) async {
    late final String stringValue;

    if (value == null) {
      throw ArgumentError('Cannot store null value for key: $key');
    }

    if (value is String) {
      stringValue = value;
    } else if (value is int || value is double || value is bool) {
      stringValue = value.toString();
    } else if (value is Map<String, dynamic> || value is List) {
      stringValue = jsonEncode(value);
    } else {
      throw UnsupportedError('Type ${value.runtimeType} is not supported for secure storage');
    }

    try {
      await _storage.write(key: key, value: stringValue);
    } catch (e) {
      debugPrint('Secure storage write failed for "$key": $e');
    }
  }

  @override
  Future<T?> read<T>(String key) async {
    late final String? value;
    try {
      value = await _storage.read(key: key);
    } catch (e) {
      debugPrint('Secure storage read failed for "$key": $e');
      return null;
    }
    if (value == null) return null;

    if (T == String) return value as T;
    if (T == int) return int.tryParse(value) as T?;
    if (T == double) return double.tryParse(value) as T?;
    if (T == bool) return (value.toLowerCase() == 'true') as T?;

    if (T == Map<String, dynamic>) {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return decoded as T;
      }
      throw FormatException('Stored value is not a Map<String, dynamic>');
    }

    if (T == List<Map<String, dynamic>>) {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>() as T;
      }
      throw FormatException('Stored value is not a List<Map<String, dynamic>>');
    }

    throw UnsupportedError('Type $T is not supported');
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint('Secure storage delete failed for "$key": $e');
    }
  }

  @override
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      debugPrint('Secure storage readAll failed: $e');
      return {};
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('Secure storage deleteAll failed: $e');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      String? value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      debugPrint('Secure storage containsKey failed for "$key": $e');
      return false;
    }
  }

  @override
  Future<void> saveLocale(String localeCode) async {
    await write('locale', localeCode);
  }

  @override
  Future<String?> getLocale() async {
    return read<String>('locale');
  }

  @override
  Future<void> writeIntList(String key, List<int> value) async {
    if (value.isEmpty) {
      await write(key, '');
      return;
    }

    final stringValue = value.join(','); // 1,2,3,4
    await write(key, stringValue);
  }

  @override
  Future<List<int>?> readIntList(String key) async {
    final String? value = await read<String>(key);

    if (value == null || value.isEmpty) return [];

    try {
      return value.split(',').map((e) => int.parse(e)).toList();
    } catch (e) {
      throw FormatException('Stored value is not a valid List<int>');
    }
  }
}
