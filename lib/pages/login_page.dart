import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final AuthService authService;
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap, required this.authService});

  login(BuildContext context) async {
    if(_emController.text.isEmpty || _pwController.text.isEmpty) {
      return;
    }

    try {
      await authService.signInWithEmailPassword(
        _emController.text,
        _pwController.text,
      );

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 50),
          Text(
            "欢迎回来!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
          MyTextField(
            hintText: "邮箱",
            obscureText: false,
            controller: _emController,
          ),
          const SizedBox(height: 10),
          MyTextField(
            hintText: "密码",
            obscureText: true,
            controller: _pwController,
          ),
          const SizedBox(height: 25),
          MyButton(text: "登录", onTap: () => login(context)),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("没有账号?"),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "去注册",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
