//
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ortho_waiting_list/api/auth/api_auth.dart';
import 'package:ortho_waiting_list/models/app_user.dart';

class PxAuth extends ChangeNotifier {
  final AuthApi api;

  PxAuth({
    required this.api,
  });

  static RecordAuth? _auth;
  RecordAuth? get authModel => _auth;

  static AppUser? _user;
  AppUser? get user => _user;

  Future<void> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    try {
      final result = await api.loginWithEmailAndPassword(
        email,
        password,
        rememberMe,
      );
      _auth = result;
      _user = AppUser.fromRecordAuth(_auth!);
      notifyListeners();
    } catch (e) {
      _auth = null;
      _user = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loginWithToken() async {
    // print('PxAuth().loginWithToken()');
    String _info = '';
    try {
      _auth = await api.loginWithToken();
      _user = AppUser.fromRecordAuth(_auth!);
      notifyListeners();
      _info = 'try';
      print('PxAuth().loginWithToken($_info)');
    } catch (e) {
      _auth = null;
      _user = null;
      notifyListeners();
      _info = 'catch';
      print('PxAuth().loginWithToken($_info)');

      rethrow;
    }
  }

  void logout() {
    try {
      api.logout();
      _auth = null;
      _user = null;
    } catch (e) {
      print(e.toString());
    }
  }

  bool get isLoggedIn => _auth != null;

  String get doc_id => _auth!.record.id;

  Future<void> changePassword() async {
    if (_user != null) {
      await api
          .requestResetPassword(user!.auth!.record.getStringValue('email'));
    }
  }

  Future<void> forgotPassword(String email) async {
    await api.requestResetPassword(email);
  }
}
