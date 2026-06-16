import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/core/constants/storage_keys.dart';

class CalendarCacheStorage {
  Future<int?> getScheduleVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(StorageKeys.scheduleVersion);
  }

  Future<void> saveScheduleVersion(int version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(StorageKeys.scheduleVersion, version);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.scheduleVersion);
  }
}
