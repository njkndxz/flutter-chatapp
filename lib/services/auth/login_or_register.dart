import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginOrRegister extends StatefulWidget {

  const LoginOrRegister({super.key});

  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  final AuthService authService = Get.find<AuthService>();

  togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginPage(onTap: togglePage, authService: authService)
        : RegisterPage(onTap: togglePage, authService: authService);
  }
}
