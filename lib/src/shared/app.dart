// ignore_for_file: unnecessary_const

import 'package:dynamic_color/dynamic_color.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import '/src/shared/provieders/theme.dart';
import 'package:openidconnect/openidconnect.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final settings = ValueNotifier(ThemeSettings(
    sourceColor: Color.fromARGB(255, 1, 14, 26),
    themeMode: ThemeMode.system,
  ));

  void weblogin(
    BuildContext context,
    OpenIdConfiguration configuration,
    String clientId,
    String callbackUrlScheme,
  ) async {
    final check = await OpenIdConnect.authorizeInteractive(
        context: context,
        title: "Login",
        request: await InteractiveAuthorizationRequest.create(
            clientId: clientId,
            redirectUrl: callbackUrlScheme,
            useWebPopup: true,
            autoRefresh: false,
            configuration: configuration,
            scopes: ["email"]));
    print(check?.accessToken);
  }

  void desktopLogin(
    OpenIdConfiguration configuration,
    String clientId,
    String callbackUrlScheme,
  ) async {
    print("desktop");
    final check = await OpenIdConnect.authorizeDevice(
        request: DeviceAuthorizationRequest(
            clientId: clientId,
            configuration: configuration,
            scopes: ["email"],
            audience: ''));
    print(check.accessToken);
    final userinfo = await OpenIdConnect.getUserInfo(
        request: UserInfoRequest(
            accessToken: check.accessToken,
            configuration: configuration,
            tokenType: check.tokenType));
    print(userinfo.entries);
  }

  @override
  Widget build(BuildContext context) {
    /*DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => ThemeProvider(
          lightDynamic: lightDynamic,
          darkDynamic: darkDynamic,
          settings: settings,
          child: NotificationListener<ThemeSettingChange>(
            onNotification: (notification) {
              settings.value = notification.settings;
              return true;
            },
            child: ValueListenableBuilder<ThemeSettings>(
              valueListenable: settings,
              builder: (context, value, _) {
                final theme = ThemeProvider.of(context);

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: theme.light(settings.value.sourceColor),
                  darkTheme: theme.dark(settings.value.sourceColor),
                  themeMode: theme.themeMode(),
                  home: Scaffold(
                      appBar: AppBar(
                        title: const Text('AppBar Demo'),
                      ),
                      body: Container(
                          child: KeyboardListener(
                        child: Text("sdfsf"),
                        focusNode: new FocusNode(),
                        onKeyEvent: (KeyEvent e) => print(e),
                      ))),
                );
              },
            ),
          )),
    )*/

    return FluentApp(
      home: IconButton(
        // ignore: avoid_print
        icon: Icon(FluentIcons.add),
        onPressed: () async {
          final googleClientId = 'testclient';
          final callbackUrlScheme = 'http://localhost:8081/callback.html';
          final discoveryUrl =
              'http://localhost:8080/realms/testrlm/.well-known/openid-configuration';
          final configuration =
              await OpenIdConnect.getConfiguration(discoveryUrl);
          if (kIsWeb) {
            /// Working Web with
            weblogin(context, configuration, googleClientId, callbackUrlScheme);
          } else {
            // working desktop
            desktopLogin(configuration, googleClientId, callbackUrlScheme);
          }
        },
        //child: const Text("Hi First Button")
      ),
    );
  }
}
