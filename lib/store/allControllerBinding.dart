import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:get/get.dart';


/* 
  在我们使用 GetX 状态管理器的时候，往往每次都是用需要手动实例化一个控制器，这样的话基本页面
  都需要实例化一次，这样就太麻烦了，而 Binding 能解决上述问题，可以在项目初始化时把所有需要
  进行状态管理的控制器进行统一初始化
 */
class Allcontrollerbinding implements Bindings {
  @override
  void dependencies() {
    // 声明需要进行的绑定控制器类
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<ChatService>(() => ChatService());
  }
}