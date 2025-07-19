import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  // 初始化supabse
  final SupabaseClient supabase = Supabase.instance.client;

  User? user;

  // 登录
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      user = res.user;

      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 注册
  Future<AuthResponse> signUp(
    String email,
    String password,
    String confirmPw,
  ) async {
    try {
      if (password != confirmPw) {
        throw Exception("两次输入的密码不一致!");
      }

      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      user = res.user;

      if (res.user != null) {
        await supabase.from('users').insert([{
          "id": res.user?.id,
          "email": email,
          "password": password,
          "uid": res.user?.id,
        }]);
      }

      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 退出
  void signOut() async {
    try {
      await supabase.auth.signOut();
      user = null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 获取当前用户登录状态
  Future<UserResponse?> checkUser() async {
    try {
      final UserResponse data = await supabase.auth.getUser();
      return data;
    } catch (e) {
      throw Exception('76=>$e');
    }
  }
}
