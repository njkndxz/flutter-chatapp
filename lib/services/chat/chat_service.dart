import 'dart:async';

import 'package:chat_app/modals/message.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService extends GetxController {
  // 初始化
  final supabase = Supabase.instance.client;

  // 获取用户列表
  Future<List<Map<String, dynamic>>> getUserList() async {
    try {
      List<Map<String, dynamic>> res = await supabase
          .from('users')
          .select('id, email, display_name, uid, last_message')
          .order('created_at', ascending: false);

      return res;
    } catch (e) {
      throw Exception('22=>$e');
    }
  }

  // 实时获取用户列表
  SupabaseStreamBuilder getRealTimeUserList() {
    return supabase
        .from('users')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  // 发送消息
  Future<void> sendMessage(
    String currentUserID,
    String currentUserEMail,
    String receiverID,
    message,
  ) async {
    final String timestamp = DateTime.now().toString();

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEMail,
      receiverID: receiverID,
      message: message.toString(),
      timestamp: timestamp,
      chatRoomID: chatRoomID,
    );

    try {
      await supabase.from('chat_rooms').upsert(newMessage.toMap()).select();
    } catch (e) {
      throw Exception('59=>$e');
    }
  }

  // 获取消息
  SupabaseStreamBuilder getMessage(String senderID, String receiverID) {
    List<String> ids = [senderID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return supabase
        .from('chat_rooms')
        .stream(primaryKey: ['chatRoomID'])
        .eq('chatRoomID', chatRoomID)
        .order('timestamp', ascending: true);
  }

  // 拉黑用户
  Future<void> blockUser(
    String blockedUserid,
    String blockedUserEmail,
    String targetUserId,
  ) async {
    try {
      await supabase.from('blocked_users').insert([
        {
          'blocked_userId': blockedUserid,
          'blocked_userEmail': blockedUserEmail,
          'target_userId': targetUserId,
        },
      ]).select();
    } catch (e) {
      throw Exception('$e');
    }
  }

  // 解除拉黑
  Future<void> unBlockUser(String blockedUserid) async {
    try {
      await supabase
          .from('blocked_users')
          .delete()
          .eq('blocked_userId', blockedUserid);
    } catch (e) {
      throw Exception('$e');
    }
  }

  // 获取拉黑的用户列表
  SupabaseStreamBuilder getBlockedUserList() {
    return supabase
        .from('blocked_users')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  // 获取没有被拉黑的用户列表
  Stream getUnBlockedUserList(AuthService authService) {
    return supabase
        .from('users')
        .select(
          'id, email, display_name, uid, last_message, blocked_users(blocked_userId, blocked_userEmail)',
        )
        .order('created_at')
        .asStream()
        .asyncMap((snapshot) {
          List list = List.empty();
          if (authService.user?.id != null) {
            List currentUserList = snapshot
                .where((user) => authService.user?.id == user['id'])
                .toList();

            List blockedUsers = List.from(currentUserList[0]['blocked_users']);

            List currentBlockedUsersId = blockedUsers
                .map((data) => data['blocked_userId'])
                .toList();

            return snapshot
                .where(
                  (user) =>
                      authService.user?.id != user['id'] &&
                      !currentBlockedUsersId.contains(user['id']),
                )
                .toList();
          } else {
            return list;
          }
        });
  }
}
