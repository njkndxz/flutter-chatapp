// 1.配置iOS风格的路由，删掉material.dart，引入cupertino.dart
import 'package:chat_app/pages/blockUser_page.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:chat_app/services/auth/login_or_register.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:flutter/cupertino.dart';


final Map routes = {
  '/': (context) => const HomePage(),
  '/login': (context) => const LoginOrRegister(),
  '/chat': (context, {arguments}) => ChatPage(arguments: arguments),
  '/settings': (context) => SettingsPage(),
  '/blockUser': (context) => BlockUserPage()
};
/* 
  首先在 MaterialApp 中去掉 routes 属性，然后添加 onGenerateRoute 属性。
  onGenerateRoute 接收的是一个函数，先按照下面的固定写法写就好了。
  将路由配置提取成一个变量，在 onGenerateRoute 中会用到。
*/
var onGenerateRoute = (RouteSettings settings) {
  // name 这里会拿到路由的名称，也就是/search
  final String? name = settings.name;
  // 通过/search，在路由配置字典中拿到对应的函数(context, {arguments}) => SearchPage(arguments: arguments)。
  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    // 查看跳转有没有携带参数
    if (settings.arguments != null) {
      // 如果携带了参数，则调用路由配置中对应的函数，将参数传递进去，也就是调用了SearchPage中的构造函数，最终创建了路由对象
      final Route route = CupertinoPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments),
      );
      return route;
    } else {
      // 如果跳转没有携带参数，调用pageContentBuilder不带参数
      final Route route = CupertinoPageRoute(
        builder: (context) => pageContentBuilder(context),
      );
      return route;
    }
  }
  return null;
};
