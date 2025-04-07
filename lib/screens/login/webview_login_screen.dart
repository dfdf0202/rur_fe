import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLoginScreen extends StatefulWidget {
  final String loginUrl;

  const WebViewLoginScreen({super.key, required this.loginUrl});

  @override
  State<WebViewLoginScreen> createState() => _WebViewLoginScreenState();
}

class _WebViewLoginScreenState extends State<WebViewLoginScreen> {
  late final WebViewController _controller;
  late final String callbackPath;

  @override
  void initState() {
    super.initState();

    // 1. loginUrl 안에서 redirect_uri 추출
    final loginUri = Uri.parse(widget.loginUrl);
    final redirectUriRaw = loginUri.queryParameters['redirect_uri'];
    final redirectUri =
        redirectUriRaw != null ? Uri.parse(redirectUriRaw) : null;
    callbackPath = redirectUri?.path ?? '/auth/callbackKakao'; // fallback

    // 2. WebView 설정
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                final uri = Uri.parse(request.url);
                if (uri.path == callbackPath) {
                  final code = uri.queryParameters['code'];

                  if (code != null && mounted) {
                    Navigator.pushNamed(
                      context,
                      callbackPath,
                      arguments: {
                        'code': code,
                        'redirectUri': redirectUri.toString(),
                      },
                    );
                  }
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.loginUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: _controller));
  }
}
