import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/contador_repository.dart';

class ContadorPrefsRepository implements ContadorRepository {
  static const _claveContador = 'contador';

  final SharedPreferencesAsync _preferences;

  ContadorPrefsRepository({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  @override
  Future<int> leer() async {
    return await _preferences.getInt(_claveContador) ?? 0;
  }

  @override
  Future<void> guardar(int valor) async {
    await _preferences.setInt(_claveContador, valor);
  }
}
