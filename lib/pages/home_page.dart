import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService chatService = Get.find<ChatService>();
  final AuthService authService = Get.find<AuthService>();

  // late List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();
    // checkAuth();
    // getUserList();
  }

  /* checkAuth() async {
    try {
      final res = await authService.checkUser();
      if (res?.user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  } */

  logout() {
    authService.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      ModalRoute.withName('/login'),
    );
  }

  /* getUserList() async {
    try {
      var result = await chatService.getUserList();
      
      setState(() {
        userList = result;
      });
    } catch (e) {
      throw Exception('56=>$e');
    }
  } */

  String? getCurrentUserEmail() {
    return authService.user?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("首页"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
        /* actions: [
          GestureDetector(
            onTap: getUserList,
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: const Icon(Icons.refresh),
            ),
          ),
        ], */
      ),
      drawer: MyDrawer(logout: logout),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: chatService.getUnBlockedUserList(authService),
      builder: (context, snapshot) {
        if (authService.user == null) {
          return const SizedBox();
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List userList = snapshot.data ?? [];

        if(userList.isEmpty) {
          return const Center(
            child: Text("暂无用户好友"),
          );
        }

        return ListView(
          children: userList
              .map((userData) => _buildUserListItem(context, userData))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
    BuildContext context,
    Map<String, dynamic> userData
  ) {
    return userData['email'] == getCurrentUserEmail()
        ? const SizedBox()
        : UserTile(
            text: userData['email'],
            onTap: () {
              Navigator.pushNamed(
                context,
                '/chat',
                arguments: {
                  "receiverEmail": userData['email'],
                  "receiverID": userData['id'],
                  "senderID": authService.user?.id,
                  "senderEmail": authService.user?.email,
                },
              );
            },
          );
  }
}
