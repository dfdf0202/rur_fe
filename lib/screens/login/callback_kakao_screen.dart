import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth_api.dart';

class CallbackKakoScreen extends StatefulWidget {
  const CallbackKakoScreen({super.key});

  @override
  State<CallbackKakoScreen> createState() => _CallbackKakoScreenState();
}

class _CallbackKakoScreenState extends State<CallbackKakoScreen> {
  String? code;
  String? redirectUri;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      code = args?['code'];
      redirectUri = args?['redirectUri'];

      if (code != null && redirectUri != null) {
        _doLogin(code!, redirectUri!);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _doLogin(String code, String callbackUrl) async {
    final response = await AuthApi.login(code: code, callbackUrl: callbackUrl);

    if (response != null) {
      // ✅ accessToken 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response.accessToken);

      // ✅ 분기 처리
      if (response.isMemberGroup) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      } else {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/invite-code',
          (_) => false,
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인 실패')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : const Center(child: Text('로그인 처리 실패')),
    );
  }
}
