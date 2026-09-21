import 'package:hive/hive.dart';

class UserConfig {
  static const String _boxName = 'user_config';
  static const String _nameKey = 'user_name';
  static const String _initialBalanceKey = 'initial_balance';
  static const String _isConfiguredKey = 'is_configured';
  static const String _initialNotificationsValue = 'initial_notifications';

  /// Verifica si el usuario ya configuró su perfil
  static Future<bool> isUserConfigured() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_isConfiguredKey, defaultValue: false);
  }

  /// Guarda la configuración inicial del usuario
  static Future<void> saveUserConfig({
    required String name,
    required double initialBalance,
  }) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_nameKey, name);
    await box.put(_initialBalanceKey, initialBalance);
    await box.put(_isConfiguredKey, true);
  }

  /// Obtiene el nombre del usuario
  static Future<String> getUserName() async {
    final box = await _openBox();
    return box.get(_nameKey, defaultValue: 'Usuario');
  }

  /// Obtiene el balance inicial del usuario
  static Future<double> getInitialBalance() async {
    final box = await _openBox();
    return box.get(_initialBalanceKey, defaultValue: 0.0);
  }

  static Future<void> updateInitialBalance(double newBalance) async {
    final box = await _openBox();
    await box.put(_initialBalanceKey, newBalance);
  }

  static Future<void> updateNotificationsOption(String status) async {
    final box = await _openBox();
    await box.put(_initialNotificationsValue, status);
  }

  static Future<String> checkNotificationsOption() async {
    final box = await _openBox();
    return await box.get(_initialNotificationsValue);
  }

  static Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }
}
