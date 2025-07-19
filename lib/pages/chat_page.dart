import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  final Map arguments;

  const ChatPage({super.key, required this.arguments});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map arguments = {};
  final ChatService chatService = Get.find<ChatService>();
  final AuthService authService = Get.find<AuthService>();

  final TextEditingController _msgController = TextEditingController();
  // 滚动控制器
  final ScrollController _scrollController = ScrollController();
  // 文本焦点
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 获取传参
    arguments = widget.arguments;

    myFocusNode.addListener(() {
      // 加个延迟让输入键盘出来再让列表往下滚动
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    // 刚进消息页面时等列表创建好再滚动到底部
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _msgController.dispose();
    super.dispose();
  }

  scrollDown() {
    if (_scrollController.positions.isNotEmpty) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  sendMessage() async {
    if (_msgController.text.isNotEmpty) {
      await chatService.sendMessage(
        arguments['senderID'],
        arguments['senderEmail'],
        arguments['receiverID'],
        _msgController.text,
      );
    }
    _msgController.clear();

    // 发送完消息列表滚动到底部
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(arguments['receiverEmail']),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          // 显示消息
          Expanded(child: _buildMessageList()),

          // 输入框
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.getMessage(
        arguments['senderID'],
        arguments['receiverID'],
      ),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const SizedBox();
        }
        // return your widget with the data from snapshot
        return ListView(
          controller: _scrollController,
          children: snapshot.data!
              .map((data) => _buildMessageItem(data))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> data) {
    // 区分用户
    bool isCurrentUser = arguments['senderID'] == data['senderID'];

    // 修改样式
    var alginment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alginment,
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            userId: arguments['receiverID'],
            userEmail: arguments['receiverEmail'],
            senderID: arguments['senderID'],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // 输入框
          Expanded(
            child: MyTextField(
              hintText: "",
              obscureText: false,
              controller: _msgController,
              focusNode: myFocusNode,
            ),
          ),
          //提交
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
