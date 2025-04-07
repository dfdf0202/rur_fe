import 'package:fe_app/screens/login/webview_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/auth_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String? loginUrl; // ← 받은 로그인 URL 저장

  @override
  void initState() {
    super.initState();

    // 로고 움직이는 애니메이션 설정
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    fetchLoginPath();
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 리소스 정리
    super.dispose();
  }

  Future<void> fetchLoginPath() async {
    final url = await AuthApi.getLoginPath();
    setState(() {
      loginUrl = url;
    });
  }

  Future<void> openLoginUrl() async {
    if (loginUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인 URL을 불러오지 못했어요 😢')));
      return;
    }

    final uri = Uri.parse(loginUrl!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('❌ URL 열기 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_animation.value),
                  child: child,
                );
              },
              child: Image.asset('assets/images/logo.png', width: 120),
            ),
            const SizedBox(height: 24),
            const Text(
              '너 얼마씀?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A3A3A),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                if (loginUrl == null) return;

                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewLoginScreen(loginUrl: loginUrl!),
                  ),
                );

                if (result == true) {
                  // 로그인 성공 처리 (ex: 홈 화면 이동 등)
                  print('✅ 로그인 성공!');
                }
              },
              child: Image.asset(
                'assets/images/kakao_login_medium_wide.png',
                width: 240,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
