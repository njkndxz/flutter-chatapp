import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/routers/router.dart';
import 'package:chat_app/store/allControllerBinding.dart';
import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


const supabaseUrl = 'https://wquadwsbjgcvqapgeqth.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndxdWFkd3NiamdjdnFhcGdlcXRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MzAyOTksImV4cCI6MjA2ODIwNjI5OX0.iYx6HEybB3MWvYhmH2aMjzvA2uOdJzs4M-GJe0_P_8A';

Future<void> main() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  runApp(MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.light,
      home: const HomePage(),
      initialBinding: Allcontrollerbinding(),
      initialRoute: '/login',
      onGenerateRoute: onGenerateRoute,
      defaultTransition: Transition.rightToLeftWithFade,
    );
  }
}
