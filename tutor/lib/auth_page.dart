import 'package:flutter/material.dart';
import 'models/models.dart';
import 'data/constants.dart';
import 'package:tutor/locale/locales.dart';
import 'package:tutor/widgets/widgets.dart' as ui;
import 'package:tutor/find_me.dart';
import 'services/create_user_service.dart';
import 'dart:convert';

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
  static int _regIdx          = 0;
  RegistrationStep _step      = RegistrationStep.EMAIL;

  static final _emailKey      = GlobalKey<FormState>();
  static final _passwordKey   = GlobalKey<FormState>();
  static final _namesKey      = GlobalKey<FormState>();
  bool _emailAutoValidate     = false;
  bool _passwordAutoValidate  = false;
  bool _usernameAutoValidate  = false;

  CreateUserService createUserService = CreateUserService();

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case RegistrationStep.EMAIL:
        return _emailScreen();
      case RegistrationStep.PASSWORD:
        return _passwordScreen();
      case RegistrationStep.NAMES:
        return _namesScreen();
      default:
        return Container();
    }
  }

  void _handleNext() {
    setState(() {
      if (_regIdx < registrationSteps.length) {
        _step = registrationSteps[++_regIdx];
      } else {
        Navigator.of(context).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) => FindMePage())
        );
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (_regIdx > 0) {
      setState(() {
        _step = registrationSteps[--_regIdx];
      });
      return false;
    }
    return true;
  }

  String _validateEmail(String email) {
    RegExp regex = RegExp(emailRegex);
    if (!regex.hasMatch(email)) {
      return AppLocalizations.of(context).emailValidator;
    } else
      return null;
  }

  String _validatePassword(String password) {
    if (password.length < passwordMinLength) {
      return AppLocalizations.of(context).passwordValidatorLength;
    } else if (RegExp(alphaRegex).hasMatch(password)) {
      return AppLocalizations.of(context).passwordValidatorAlpha;
    } else
      return null;
  }

  String _validateNames(String name) => name.isNotEmpty
      ? null
      : AppLocalizations.of(context).nameValidatorEmpty;

  String _validateUsername(String username) {
    Map raw;
    createUserService.verifyUsername(username).then((String response) {
      raw = json.decode(response);
      print(raw);
    });
    return null;
  }

  void _saveInput(GlobalKey<FormState> key, bool validate) {
    if (key.currentState.validate()) {
      key.currentState.save();
    } else {
      validate = true;
    }
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
                          labelStyle: regFormsHintStyle,
                        ),
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
                            _saveInput(_emailKey, _emailAutoValidate);
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
                          labelText:
                              AppLocalizations.of(context).passwordPromptAgain,
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
                          _saveInput(_passwordKey, _passwordAutoValidate);
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

  Widget _namesScreen() {
    return root(Form(
      key: _namesKey,
      child: Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('', style: regFormsHintStyle,),
                Text(
                  AppLocalizations.of(context).nameScreenWarning,
                  style: regFormsHintStyle,
                ),
                Text('', style: regFormsHintStyle,),
                TextFormField(
                  validator: _validateNames,
                  onSaved: (String name) => widget.user.firstName = name,
                  decoration:
                      InputDecoration(
                        labelText: AppLocalizations.of(context).firstNameFieldLabel,
                        labelStyle: regFormsHintStyle
                      ),
                ),
                TextFormField(
                  validator: _validateNames,
                  onSaved: (String name) => widget.user.lastName = name,
                  decoration:
                  InputDecoration(
                      labelText: AppLocalizations.of(context).lastNameFieldLabel,
                      labelStyle: regFormsHintStyle
                  ),
                ),
                TextFormField(
                  validator: _validateUsername,
                  onSaved: (String name) => widget.user.username = name,
                  decoration:
                  InputDecoration(
                      labelText: AppLocalizations.of(context).usernameFieldLabel,
                      hintText: AppLocalizations.of(context).usernameFieldHint,
                      labelStyle: regFormsHintStyle
                  ),
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
                    _saveInput(_namesKey, _usernameAutoValidate);
                    print('current first name: ' + widget.user.firstName);
                    print('current last name: ' + widget.user.lastName);
                    print('current user name: ' + widget.user.username);
                    createUserService.createUser(widget.user).then((response) {
                      _handleNext();
                    });
                  }),
              ],
            ),
          )
        ],
      ),
    )));
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
