import 'package:flutter/material.dart';
import 'models/models.dart';
import 'data/constants.dart';

List<RegistrationStep> registrationSteps = <RegistrationStep>[
  RegistrationStep.EMAIL,
  RegistrationStep.PASSWORD,
];


class AuthPage extends StatefulWidget {
  AuthPage({Key key, this.auth, this.onSignIn, this.user}) : super(key: key);

  final User user;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  static int _regIdx = 0;
  RegistrationStep _step = RegistrationStep.EMAIL;
  static final emailKey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case RegistrationStep.EMAIL:    return _emailScreen();
      case RegistrationStep.PASSWORD: return _passwordScreen();
      default:                        return Container();
    }
  }

  void _handleForward() {
    setState(() {
      if (_regIdx < registrationSteps.length) {
        _step = registrationSteps[++_regIdx];
      }
    });
  }

  Widget _emailScreen() {
    return Scaffold(
      body: Container(
        child: Center(
          child: Form(
            key: emailKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextFormField(
                onSaved: (String email) => widget.user.email = email.trim(),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: emailPrompt,
                ),
              ),
            )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _handleForward),
    );
  }

  Widget _passwordScreen() {
    return Scaffold(
      body: Container(
        child: Center(child: Text('Password '  + _regIdx.toString() + _step.toString(), style: TextStyle(fontSize: 25),)),
      ),
    );
  }
}

abstract class BaseAuth {
  Future<String> currentUser();
  Future<String> signIn(String username, String password);
  Future<void> signOut();
  Future<String> createUser();
}

enum RegistrationStep {
  EMAIL, PASSWORD
}