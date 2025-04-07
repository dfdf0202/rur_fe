import 'package:fe_app/screens/home/home_screen.dart';
import 'package:fe_app/screens/member/invite_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/callback_kakao_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    print("=======================");
    print('token : $token');
    if (token != null && token.isNotEmpty) {
      debugPrint('🟢 accessToken 존재 → /invite-code 이동');
      return '/invite-code';
    }

    debugPrint('🔴 accessToken 없음 → /login 이동');
    return '/login';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '너 얼마씀?',
      theme: ThemeData(
        fontFamily: 'GmarketSans',
        scaffoldBackgroundColor: const Color(0xFFFDF6E4),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/auth/callbackKakao': (context) => const CallbackKakoScreen(),
        '/invite-code': (context) => const InviteCodeScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<String>(
  //     future: _getInitialRoute(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState != ConnectionState.done) {
  //         return const MaterialApp(
  //           home: Scaffold(body: Center(child: CircularProgressIndicator())),
  //         );
  //       }

  //       final route = snapshot.data;

  //       // ✅ fallback 처리: routes 에 존재하지 않으면 '/login' 으로 강제
  //       final validRoutes = {
  //         '/': (context) => const SplashScreen(),
  //         '/login': (context) => const LoginScreen(),
  //         '/auth/callbackKakao': (context) => const CallbackKakoScreen(),
  //         '/invite-code': (context) => const InviteCodeScreen(),
  //       };

  //       final initialRoute =
  //           (route != null && validRoutes.containsKey(route))
  //               ? route
  //               : '/login';

  //       return MaterialApp(
  //         debugShowCheckedModeBanner: false,
  //         title: 'Victory Fairy',
  //         theme: ThemeData(
  //           fontFamily: 'GmarketSans',
  //           scaffoldBackgroundColor: const Color(0xFFFDF6E4),
  //         ),
  //         initialRoute: initialRoute,
  //         routes: validRoutes,
  //       );
  //     },
  //   );
  // }
}
