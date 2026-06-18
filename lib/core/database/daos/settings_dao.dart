import 'package:drift/drift.dart';
import '../database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [UserSettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  static const _defaultId = 'default';

  Future<UserSettingsEntry?> getSettings() {
    return (select(userSettingsTable)
          ..where((s) => s.id.equals(_defaultId)))
        .getSingleOrNull();
  }

  Future<UserSettingsEntry> getOrCreateSettings() async {
    final existing = await getSettings();
    if (existing != null) return existing;

    final now = DateTime.now();
    final entry = UserSettingsEntry(
      id: _defaultId,
      appLockEnabled: 0,
      currency: 'INR',
      firstLaunchCompleted: 0,
      privacyModeEnabled: 0,
      debugModeEnabled: 0,
      createdAt: now,
      updatedAt: now,
    );
    await into(userSettingsTable).insert(entry);
    return entry;
  }

  Future<int> updateSettings(UserSettingsEntry entry) {
    return (update(userSettingsTable)..whereSamePrimaryKey(entry))
        .write(entry.copyWith(updatedAt: Value(DateTime.now())));
  }

  Future<void> updateAppLock(bool enabled) async {
    final settings = await getOrCreateSettings();
    await updateSettings(settings.copyWith(
      appLockEnabled: enabled ? 1 : 0,
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateCurrency(String currency) async {
    final settings = await getOrCreateSettings();
    await updateSettings(settings.copyWith(
      currency: currency,
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> completeFirstLaunch() async {
    final settings = await getOrCreateSettings();
    if (settings.firstLaunchCompleted == 0) {
      await updateSettings(settings.copyWith(
        firstLaunchCompleted: 1,
        updatedAt: Value(DateTime.now()),
      ));
    }
  }

  Future<void> togglePrivacyMode() async {
    final settings = await getOrCreateSettings();
    await updateSettings(settings.copyWith(
      privacyModeEnabled: settings.privacyModeEnabled == 0 ? 1 : 0,
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> toggleDebugMode() async {
    final settings = await getOrCreateSettings();
    await updateSettings(settings.copyWith(
      debugModeEnabled: settings.debugModeEnabled == 0 ? 1 : 0,
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<bool> isFirstLaunch() async {
    final settings = await getSettings();
    return settings == null || settings.firstLaunchCompleted == 0;
  }

  Future<void> resetSettings() async {
    await (delete(userSettingsTable)
          ..where((s) => s.id.equals(_defaultId)))
        .go();
  }
}
