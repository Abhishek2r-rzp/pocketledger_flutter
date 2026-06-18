import 'package:local_auth/local_auth.dart';

class BiometricManager {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canUseBiometrics() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<BiometricType> biometricType() async {
    try {
      final available = await _auth.getAvailableBiometrics();
      if (available.contains(BiometricType.face)) {
        return BiometricType.face;
      } else if (available.contains(BiometricType.fingerprint)) {
        return BiometricType.fingerprint;
      } else if (available.contains(BiometricType.iris)) {
        return BiometricType.iris;
      }
      return BiometricType.fingerprint;
    } catch (e) {
      return BiometricType.fingerprint;
    }
  }

  Future<bool> authenticate({String reason = 'Authenticate to access PocketLedger'}) async {
    try {
      final canCheck = await canUseBiometrics();
      if (!canCheck) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      return false;
    }
  }
}
