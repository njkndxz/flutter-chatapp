import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockUserPage extends StatelessWidget {
  BlockUserPage({Key? key}) : super(key: key);

  final ChatService chatService = Get.find<ChatService>();
  final AuthService authService = Get.find<AuthService>();

  _showUnblockBox(BuildContext context, String userId) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("解除屏蔽此用户"),
      content: const Text("确定要解除屏蔽吗?"),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text("取消")),
        TextButton(onPressed: () {
          chatService.unBlockUser(userId);
          Navigator.pop(context);
          ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("用户取消屏蔽")));
        }, child: const Text("确定")),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("屏蔽的用户")),
      body: StreamBuilder(
        stream: chatService.getBlockedUserList(),
        builder: (context, snapshot) {
          // 出错了
          if(snapshot.hasError) {
            return const Center(
              child: Text("加载出错..."),
            );
          }
          // 加载中
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blockedUsers = snapshot.data ?? [];
          // 没有用户时
          if(blockedUsers.isEmpty) {
            return const Center(child: Text("没有被屏蔽的用户"),);
          }

          // 加载完成
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
            final user = blockedUsers[index];
            if(authService.user!.id == user["target_userId"]) {
              return UserTile(text: user["blocked_userEmail"], onTap: () => _showUnblockBox(context, user['blocked_userId']),);
            } 
            return null;
          });
        },
      ),
    );
  }
}
