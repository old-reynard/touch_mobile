import 'package:flutter/material.dart';
import 'package:tutor/data/constants.dart';
import 'auth_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'locale/locales.dart';
import 'models/models.dart';
import 'package:tutor/profile.dart';

void main() => runApp(TutorApp());

class TutorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Root(),
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ru', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
        AppLocalizations.of(context).appName,
    );
  }
}

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  AuthStatus status = AuthStatus.signedIn;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AuthStatus.signedIn:
        return ProfilePage();
      case AuthStatus.notSignedIn:
        return AuthPage(
          user: User(),
          onSignIn: () => _changeStatus(AuthStatus.signedIn),
        );
      default:
        return Container();
    }
  }

  void _changeStatus(AuthStatus newStatus) {
    setState(() {
      status = newStatus;
    });
  }
}


enum AuthStatus { notSignedIn, signedIn }
