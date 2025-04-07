import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const baseUrl = 'http://10.0.2.2:6060/api/member';

  /// 1. 로그인 경로(URL) 받아오기
  static Future<String?> getLoginPath() async {
    try {
      final uri = Uri.parse('$baseUrl/auth-path');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final url = body['data']; // ✅ 여기서 data 필드 꺼내기
        return url;
      } else {
        print('❌ 로그인 경로 요청 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❗ 로그인 경로 에러: $e');
      return null;
    }
  }

  /// . 로그인 요청 (토큰 발급)
  static Future<LoginResponse?> login({
    required String code,
    required String callbackUrl,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/login',
      ).replace(queryParameters: {'code': code, 'callbackUrl': callbackUrl});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return LoginResponse.fromJson(
          body['data'],
        ); // ApiResponse wrapper 안에 'data'
      } else {
        print('❌ 로그인 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❗ 로그인 에러: $e');
      return null;
    }
  }
}

class LoginResponse {
  final int id;
  final bool isMemberGroup;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.id,
    required this.isMemberGroup,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      isMemberGroup: json['isMemberGroup'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
