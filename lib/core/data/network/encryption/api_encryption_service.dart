abstract class ApiEncryptionService {
  String encryptHeader(String plain);
  String encryptPayload(String plainJson);
  String decryptString(String encrypted);
  Map<String, dynamic> decryptResponse(String encrypted);
}
