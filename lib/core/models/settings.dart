class AppSettings {
  final bool biometricEnabled;
  final String currency;
  final bool debugMode;
  final bool onboardingCompleted;

  AppSettings({
    this.biometricEnabled = false,
    this.currency = 'INR',
    this.debugMode = false,
    this.onboardingCompleted = false,
  });

  AppSettings copyWith({
    bool? biometricEnabled,
    String? currency,
    bool? debugMode,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      currency: currency ?? this.currency,
      debugMode: debugMode ?? this.debugMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() => {
        'biometricEnabled': biometricEnabled,
        'currency': currency,
        'debugMode': debugMode,
        'onboardingCompleted': onboardingCompleted,
      };

  factory AppSettings.fromMap(Map<String, dynamic> map) => AppSettings(
        biometricEnabled: map['biometricEnabled'] as bool? ?? false,
        currency: map['currency'] as String? ?? 'INR',
        debugMode: map['debugMode'] as bool? ?? false,
        onboardingCompleted: map['onboardingCompleted'] as bool? ?? false,
      );
}
