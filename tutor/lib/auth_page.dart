import 'package:flutter/material.dart';
import 'models/models.dart';
import 'data/constants.dart';
import 'package:tutor/locale/locales.dart';
import 'package:tutor/widgets/widgets.dart' as ui;

enum RegistrationStep { EMAIL, PASSWORD, NAMES }

List<RegistrationStep> registrationSteps = RegistrationStep.values;

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
  static final _emailKey = new GlobalKey<FormState>();
  bool _emailAutoValidate = false;
  static final _passwordKey = new GlobalKey<FormState>();
  bool _passwordAutoValidate = false;

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case RegistrationStep.EMAIL:
        return _emailScreen();
      case RegistrationStep.PASSWORD:
        return _passwordScreen();
      default:
        return Container();
    }
  }

  void _handleNext() {
    setState(() {
      if (_regIdx < registrationSteps.length) {
        _step = registrationSteps[++_regIdx];
      }
    });
  }


  Future<bool> _onWillPop() async {
    if (_regIdx > 0) {
      setState(() {
        _step = registrationSteps[--_regIdx];
      });
      return true;
    }
    return false;
  }

  String _validateEmail(String email) {
    RegExp regex = RegExp(emailRegex);
    if (!regex.hasMatch(email)) {
      return AppLocalizations.of(context).emailValidator;
    } else
      return null;
  }

  void _saveEmail() {
    if (_emailKey.currentState.validate()) {
      _emailKey.currentState.save();
    } else
      _emailAutoValidate = true;
  }

  String _validatePassword(String password) {
    if (password.length < passwordMinLength) {
      return AppLocalizations.of(context).passwordValidatorLength;
    } else if (RegExp(alphaRegex).hasMatch(password)) {
      return AppLocalizations.of(context).passwordValidatorAlpha;
    } else
      return null;
  }

  void _savePassword() {
    if (_passwordKey.currentState.validate()) {
      _passwordKey.currentState.save();
    } else
      _passwordAutoValidate = true;
  }

  Widget _emailScreen() {
//    Locale thisLocale = Localizations.localeOf(context);

    return root(
      Form(
        key: _emailKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      autovalidate: _emailAutoValidate,
                      onSaved: (String email) =>
                          widget.user.email = email.trim(),
                      keyboardType: TextInputType.text,
                      validator: _validateEmail,
                      style: regFormsTextStyle,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).emailPrompt,
                          labelStyle: regFormsHintStyle),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ui.Misc.regButton(
                        text: AppLocalizations.of(context).nextButton,
                        onPress: () {
                          _saveEmail();
                          print('current email: ' + widget.user.email);
                          _handleNext();
                        }),
                  ],
                ),
              ),
            ],
          ),
        )),
    );
  }

  Widget _passwordScreen() {
    return root(
      Form(
      key: _passwordKey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    autovalidate: _passwordAutoValidate,
//                          validator: _validatePassword,
                    keyboardType: TextInputType.text,
                    onSaved: (String password) =>
                        widget.user.password = password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).passwordPrompt,
                        labelStyle: regFormsHintStyle),
                  ),
                  TextFormField(
//                          validator: (String confirm) {
//                            return confirm == widget.user.password
//                                ? null
//                                : AppLocalizations.of(context).passwordValidatorAlpha;
//                          },
                    keyboardType: TextInputType.text,
//                          onSaved: (String password) =>
//                            confirmPassword = password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .passwordPromptAgain,
                        labelStyle: regFormsHintStyle),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ui.Misc.regButton(
                      text: AppLocalizations.of(context).nextButton,
                      onPress: () {
                        _savePassword();
                        print('current password: ' + widget.user.password);
                        _handleNext();
                      })
                ],
              ),
            )
          ],
        ),
      ),
      ),
    );
  }


  Widget root(Widget kid) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          child: Center(
            child: kid,
          ),
        ),
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
