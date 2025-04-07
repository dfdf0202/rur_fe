import 'package:fe_app/api/member_api.dart';
import 'package:flutter/material.dart';

class InviteCodeScreen extends StatefulWidget {
  const InviteCodeScreen({super.key});

  @override
  State<InviteCodeScreen> createState() => _InviteCodeScreenState();
}

class _InviteCodeScreenState extends State<InviteCodeScreen> {
  final _nicknameController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  void _submit() async {
    final nickname = _nicknameController.text.trim();
    final code = _inviteCodeController.text.trim();

    if (nickname.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('닉네임과 초대코드를 모두 입력해주세요 😅')));
      return;
    }

    final request = MemberGroupRequest(nickNm: nickname, code: code);

    final response = await MemberApi.updateMemberGroup(request);

    if (response != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('초대코드 인증 실패 😢')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E4),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '초대 코드 입력',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A3A3A),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: '닉네임을 입력하세요',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _inviteCodeController,
                decoration: InputDecoration(
                  hintText: '초대 코드를 입력하세요',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A3A3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
