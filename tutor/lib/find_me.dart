import 'package:flutter/material.dart';
import 'models/models.dart';

class FindMePage extends StatefulWidget {
  FindMePage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _FindMePageState createState() => _FindMePageState();
}

class _FindMePageState extends State<FindMePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(),);
  }
}