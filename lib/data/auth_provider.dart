import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? get token => _token;

  String? get userId => Supabase.instance.client.auth.currentUser?.id;

  bool get isLoggedIn => Supabase.instance.client.auth.currentUser != null;

  void checkLoginStatus() {
    _token = isLoggedIn ? 'valid' : null;
    notifyListeners();
  }

  Map<String, String> get authHeader {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<bool> sendEmailOtp(String email) async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: email,
        emailRedirectTo:
            'io.supabase.flutter://login-callback/', // optional for web
      );
      return true;
    } catch (e) {
      print("Email OTP error: $e");
      return false;
    }
  }

  Future<bool> sendPhoneOtp(String phone) async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(phone: phone);
      return true;
    } catch (e) {
      print("Phone OTP error: $e");
      return false;
    }
  }

  Future<bool> verifyPhoneOtp(String phone, String token) async {
    try {
      final result = await Supabase.instance.client.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      );
      return result.session != null;
    } catch (e) {
      print("Phone OTP verification error: $e");
      return false;
    }
  }

  Future<bool> loginWithSupabase(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _token = 'valid';
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false;
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
    _token = null;
    notifyListeners();
  }

  User? get user => Supabase.instance.client.auth.currentUser;
}
