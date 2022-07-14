import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_strategy/url_strategy.dart';
import 'src/shared/app.dart';
import 'package:http/http.dart' as http;
import 'package:openidconnect/openidconnect.dart';

import 'package:url_launcher/url_launcher.dart';
/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    await SystemTheme.accentColor.load();
  }
  setPathUrlStrategy();
  runApp(const MainApp());
}*/

final Uri _url = Uri.parse('https://flutter.dev');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

/*
// Construct the url
  final url = Uri.http(
      'localhost:8080', '/realms/testrlm/protocol/openid-connect/auth', {
    'response_type': 'code',
    'client_id': googleClientId,
    'redirect_uri': '$callbackUrlScheme',
    'scope': 'email',
  });

  final result = await FlutterWebAuth.authenticate(
      url: url.toString(), callbackUrlScheme: callbackUrlScheme);
  print(result);
// Extract token from resulting url
  final code = Uri.parse(result).queryParameters['code'];
  print(code);
  final accurl = Uri.http(
      'localhost:8080', '/realms/testrlm/protocol/openid-connect/token', {});
  final response = await http.post(accurl, body: {
    'client_id': googleClientId,
    'redirect_uri': '$callbackUrlScheme',
    'grant_type': 'authorization_code',
    'code': code,
  });
   
  print(response.body);
// Get the access token from the response
  //final accessToken = jsonDecode(response.body)['access_token'] as String;
*/
/*  runApp(
    // FlutterWebAuth.authenticate(url: "", callbackUrlScheme: "http://localhost:8081/auth.html");

    const MaterialApp(
      home: Material(
        child: Center(
          child: ElevatedButton(
            onPressed: _launchUrl,
            child: Text('Show Flutter homepage'),
          ),
        ),
      ),
    ),
  );*/
  runApp(const MainApp());
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url, webOnlyWindowName: "_self")) {
    throw 'Could not launch $_url';
  }
}
