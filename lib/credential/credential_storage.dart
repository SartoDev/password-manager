import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'credential.dart';

class CredentialStorage {
  static const _key = 'credential-list';
  static const _uuid = Uuid();

  static Future<void> saveCredentials(List<Credential> credentials) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedList = jsonEncode(credentials.map((c) => c.toJson()).toList());
    await prefs.setString(_key, encodedList);
  }

  static Future<List<Credential>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedList = prefs.getString(_key);
    if (encodedList == null) return [];

    List<dynamic> decoded = jsonDecode(encodedList);
    return decoded.map((item) => Credential.fromJson(item)).toList();
  }

  static Future<void> addCredential(Credential credential) async {
    List<Credential> credentials = await getCredentials();

    final newCredential = credential.id == null || credential.id!.isEmpty
        ? Credential(
      id: _uuid.v4(),
      login: credential.login,
      password: credential.password,
      platform: credential.platform,
    )
        : credential;

    credentials.add(newCredential);
    await saveCredentials(credentials);
  }

  static Future<void> updateCredential(Credential updatedCredential) async {
    List<Credential> credentials = await getCredentials();
    int index = credentials.indexWhere((c) => c.id == updatedCredential.id);
    if (index != -1) {
      credentials[index] = updatedCredential;
      await saveCredentials(credentials);
    }
  }

  static Future<void> deleteCredential(String id) async {
    List<Credential> credentials = await getCredentials();
    credentials.removeWhere((c) => c.id == id);
    await saveCredentials(credentials);
  }

  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
