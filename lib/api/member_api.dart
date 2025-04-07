import 'dart:convert';
import 'package:fe_app/api/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MemberApi {
  static const baseUrl = 'http://10.0.2.2:6060/api/member';

  static Future<bool> updateMemberGroup(MemberGroupRequest request) async {
    try {
      final uri = Uri.parse('$baseUrl/invite-code');
      final headers = await getAuthHeaders();
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(body['data']);
        return body['data'];
      } else {
        print('❌ 그룹 업데이트 실패: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❗ 그룹 업데이트 에러: $e');
      return false;
    }
    return false;
  }
}

class MemberGroupRequest {
  final String nickNm;
  final String code;

  MemberGroupRequest({required this.nickNm, required this.code});

  Map<String, dynamic> toJson() {
    return {'nickNm': nickNm, 'code': code};
  }
}
