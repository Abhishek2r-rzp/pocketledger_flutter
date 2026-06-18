const _sentinel = Object();

class UserSettings {
  final bool appLockEnabled;
  final bool biometricEnabled;
  final bool cloudSyncEnabled;
  final bool exportEnabled;
  final bool firstLaunchCompleted;
  final bool debugModeEnabled;
  final bool privacyModeEnabled;
  final String currency;
  final String theme;
  final String? passcode;

  const UserSettings({
    this.appLockEnabled = false,
    this.biometricEnabled = false,
    this.cloudSyncEnabled = false,
    this.exportEnabled = true,
    this.firstLaunchCompleted = false,
    this.debugModeEnabled = false,
    this.privacyModeEnabled = false,
    this.currency = 'INR',
    this.theme = 'system',
    this.passcode,
  });

  UserSettings copyWith({
    bool? appLockEnabled,
    bool? biometricEnabled,
    bool? cloudSyncEnabled,
    bool? exportEnabled,
    bool? firstLaunchCompleted,
    bool? debugModeEnabled,
    bool? privacyModeEnabled,
    String? currency,
    String? theme,
    Object? passcode = _sentinel,
  }) {
    return UserSettings(
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      cloudSyncEnabled: cloudSyncEnabled ?? this.cloudSyncEnabled,
      exportEnabled: exportEnabled ?? this.exportEnabled,
      firstLaunchCompleted: firstLaunchCompleted ?? this.firstLaunchCompleted,
      debugModeEnabled: debugModeEnabled ?? this.debugModeEnabled,
      privacyModeEnabled: privacyModeEnabled ?? this.privacyModeEnabled,
      currency: currency ?? this.currency,
      theme: theme ?? this.theme,
      passcode: identical(passcode, _sentinel) ? this.passcode : passcode as String?,
    );
  }
}
