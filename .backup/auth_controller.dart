import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<String?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService);
});

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthController extends StateNotifier<AsyncValue<String?>> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final user = _authService.currentUser;
    if (user != null) {
      state = AsyncValue.data(user.uid);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  
  
  
  
  
  
  
  
  
  
Future<String?> signIn(String phoneNumber) async {
  state = const AsyncValue.loading();
  try {
    // Send verification code
    final verificationId = await _authService.signInWithPhoneNumber(phoneNumber); 
    // Immediately update the state with the verificationId
    state = AsyncValue.data(verificationId); 
    return verificationId;
  } catch (e) {
    state = AsyncValue.error(e, StackTrace.current);
    return null;
  }
}
  Future<void> verifySmsCode(String verificationId, String smsCode) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await _authService.verifyCode(verificationId, smsCode);
      state = AsyncValue.data(userCredential.user?.uid);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }
}
