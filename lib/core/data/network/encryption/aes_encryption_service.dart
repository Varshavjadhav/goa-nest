// import 'package:encrypt/encrypt.dart' as encrypt;
//
// import '../../../../core.dart';
//
// class AesEncryptionService implements ApiEncryptionService {
//   late final encrypt.Key _headerKey;
//   late final encrypt.Key _payloadKey;
//
//   AesEncryptionService({required String headerKey, required String payloadKey}) {
//     _headerKey = _deriveKey(headerKey);
//     _payloadKey = _deriveKey(payloadKey);
//   }
//
//   /// 🔐 AES-256 key derivation (backend-safe)
//   encrypt.Key _deriveKey(String key) {
//     final bytes = sha256.convert(utf8.encode(key)).bytes;
//     return encrypt.Key(Uint8List.fromList(bytes));
//   }
//
//   @override
//   String encryptHeader(String plain) {
//     return _encryptWithIv(plain, _headerKey);
//   }
//
//   @override
//   String encryptPayload(String plainJson) {
//     return _encryptWithIv(plainJson, _payloadKey);
//   }
//
//   @override
//   Map<String, dynamic> decryptResponse(String encrypted) {
//     final decrypted = _decryptWithIv(encrypted, _payloadKey);
//     return jsonDecode(decrypted);
//   }
//
//   @override
//   String decryptString(String encrypted) {
//     return _decryptWithIv(encrypted, _payloadKey);
//   }
//
//   // ---------------- INTERNAL ----------------
//
//   String _encryptWithIv(String plain, encrypt.Key key) {
//     final iv = encrypt.IV.fromSecureRandom(16);
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
//
//     final encrypted = encrypter.encrypt(plain, iv: iv);
//
//     /// IV + CipherText → Base64
//     return base64Encode(iv.bytes + encrypted.bytes);
//   }
//
//   String _decryptWithIv(String encryptedText, encrypt.Key key) {
//     final raw = base64Decode(encryptedText);
//
//     final iv = encrypt.IV(raw.sublist(0, 16));
//     final cipherText = raw.sublist(16);
//
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
//
//     return encrypter.decrypt(encrypt.Encrypted(cipherText), iv: iv);
//   }
// }
