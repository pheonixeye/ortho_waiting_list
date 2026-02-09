import 'package:pocketbase/pocketbase.dart';
import 'package:ortho_waiting_list/api/auth/auth_exception.dart';
import 'package:ortho_waiting_list/api/constants/pocketbase_helper.dart';
import 'package:ortho_waiting_list/utils/shared_prefs.dart';

class AuthApi {
  const AuthApi();

  static const _expandList = [
    'speciality_id',
  ];

  static final _expand = _expandList.join(',');

  //# normal login flow
  Future<RecordAuth?> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    RecordAuth? _result;
    try {
      _result = await PocketbaseHelper.pb.collection('users').authWithPassword(
            email,
            password,
            expand: _expand,
          );
    } on ClientException catch (e) {
      print(e.toString());
      throw AuthException(e);
    }

    if (rememberMe) {
      try {
        await asyncPrefs.setString('token', _result.token);
      } catch (e) {
        print("couldn't save token => ${e.toString()}");
      }
    }
    return _result;
  }

  //# remember me login flow
  Future<RecordAuth?> loginWithToken() async {
    RecordAuth? result;
    String? _token;
    try {
      _token = await asyncPrefs.getString('token');
    } catch (e) {
      print("couldn't fetch token => ${e.toString()}");
      return null;
    }
    PocketbaseHelper.pb.authStore.save(_token!, null);
    try {
      result = await PocketbaseHelper.pb.collection('users').authRefresh(
            expand: _expand,
          );
    } on ClientException catch (e) {
      print(e.toString());
      throw AuthException(e);
    }

    return result;
  }

  Future<void> requestResetPassword(String email) async {
    try {
      await PocketbaseHelper.pb.collection('users').requestPasswordReset(email);
    } on ClientException catch (e) {
      print(e.toString());
      throw AuthException(e);
    }
  }

  void logout() {
    PocketbaseHelper.pb.authStore.clear();
    asyncPrefs.remove('token');
  }
}
