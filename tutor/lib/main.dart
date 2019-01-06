import 'package:flutter/material.dart';
import 'package:tutor/data/constants.dart';
import 'auth_page.dart';

void main() => runApp(TutorApp());

class TutorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: appName,
      theme: appTheme,
      home: Root(),
    );
  }
}

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  Widget build(BuildContext context) {
    return AuthPage();
  }
}
