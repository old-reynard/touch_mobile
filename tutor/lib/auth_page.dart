import 'package:flutter/material.dart';
import 'models/models.dart';
import 'data/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tutor/locale/locales.dart';
import 'package:tutor/widgets/widgets.dart' as ui;
import 'package:tutor/find_me.dart';
import 'widgets/password_validation.dart';
import 'services/create_user_service.dart';
import 'dart:convert';
import 'dart:math' as math;

enum AuthPath { LOGIN, REGISTER }
enum RegistrationStep { EMAIL, PASSWORD, NAMES }

List<RegistrationStep> registrationSteps = RegistrationStep.values;

class AuthPage extends StatefulWidget {
  AuthPage({Key key, this.onSignIn, this.user}) : super(key: key);

  final User user;
  final VoidCallback onSignIn;

  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  static int _regIdx          = 0;
  RegistrationStep _step      = RegistrationStep.EMAIL;
  AuthPath _path              = AuthPath.REGISTER;

  static final _emailKey      = GlobalKey<FormState>();
  static final _passwordKey   = GlobalKey<FormState>();
  static final _namesKey      = GlobalKey<FormState>();

  bool _isAsyncCall           = false;

  bool _isInvalidAsyncUser    = false;
  bool _isInvalidAsyncMail    = false;

  bool _emailAutoValidate     = false;
  bool _passwordAutoValidate  = false;
  bool _usernameAutoValidate  = false;

  TextEditingController textController = TextEditingController();
  AnimationController _controller;
  Animation<double> _fabScale;

  bool enoughChars            = false;
  bool specialChar            = false;
  bool upperCase              = false;
  bool number                 = false;

  CreateUserService createUserService = CreateUserService();

  @override
  void initState() {
    super.initState();

    textController.addListener(() {
      setState(() {
        enoughChars = textController.text.length >= credentialMinLength;
        number = textController.text.contains(RegExp(r'\d'), 0);
        upperCase = textController.text.contains(RegExp(r'[A-Z]'), 0);
        specialChar = textController.text.isNotEmpty &&
          !textController.text.contains(RegExp(r'^[\w&.-]+$'), 0);
      });

      valid() ? _controller.forward() : _controller.reverse();
    });

    _controller = AnimationController(vsync: this,
        duration: Duration(milliseconds: 500));

    _fabScale = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fabScale.addListener(() {
      setState(() {});
    });
  }

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

  bool valid() =>  enoughChars && number && specialChar && upperCase;


  /// validates input after clicking Next
  void _handleNext(String type) {
    // dismiss keyboard during async call
    FocusScope.of(context).requestFocus(new FocusNode());

    // initiate async call
    setState(() {
      _isAsyncCall = true;
    });

    switch(type) {
      case emailKey:

        // verify if the email is unique
        createUserService.verifyUnique(widget.user.email, emailKey)
            .then((response) {
              setState(() {
                var data = json.decode(response);
                var email = data[emailKey];
                // email is invalid if the response is not empty
                _isInvalidAsyncMail = !(email == '');
                // finish the async call
                _isAsyncCall = false;
                // if email is valid, move forward
                if (!_isInvalidAsyncMail) _nextStep();
              });
            });
        break;
      case passwordKey:
        if (valid()) {
          setState(() {
            _isAsyncCall = false;
            _nextStep();
          });
        }
        break;
      case usernameKey:
        // verify if username is unique
        createUserService.verifyUnique(widget.user.username, usernameKey)
            .then((response) {
              setState(() {
                var data = json.decode(response);
                var username = data[usernameKey];
                _isInvalidAsyncUser = !(username == '');
                // finish async call
                _isAsyncCall = false;
                // if user is valid and forms are validated, move forward
                if (!_isInvalidAsyncUser && _namesKey.currentState.validate()) {
                  _regIdx++;
                  _nextStep();
              }
            });
          });
        break;
      default:
        break;
    }
  }

  /// moves the sign-up procedure to the next [RegistrationStep]
  /// or moves beyond the registration screen
  void _nextStep() {
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

  /// overrides default back button to move to the previous [RegistrationStep]
  Future<bool> _onWillPop() async {
    if (_regIdx > 0) {
      setState(() {
        _step = registrationSteps[--_regIdx];
        textController.clear();
      });
      return false;
    }
    return true;
  }

  /// validates email based on call to API
  /// checks validity and uniqueness
  /// returns null if email is valid
  String _validateEmail(String email) {
    RegExp regex = RegExp(emailRegex);
    if (!regex.hasMatch(email)) {
      return AppLocalizations.of(context).emailValidator;
    }

    if (_isInvalidAsyncMail && _path == AuthPath.REGISTER) {
      _isInvalidAsyncMail = false;
      return AppLocalizations.of(context).emailValidatorExists;
    }

    if (!_isInvalidAsyncMail && _path == AuthPath.LOGIN) {
      return AppLocalizations.of(context).emailValidatorUnknown;
    }

    return null;
  }

  /// validates password
  /// returns null if password is valid
  /// otherwise returns a warning
  String _validatePassword(String password) =>
    valid() ? null : AppLocalizations.of(context).passwordValidator;


  /// validates first and last names
  String _validateNames(String name) => name.isNotEmpty
      ? null
      : AppLocalizations.of(context).nameValidatorEmpty;

  /// validates username based on call to API
  /// checks validity and uniqueness
  String _validateUsername(String username) {
    if (username.length < credentialMinLength) {
      return AppLocalizations.of(context).usernameValidatorLength;
    }

    if (_isInvalidAsyncUser) {
      _isInvalidAsyncUser = false;
      return AppLocalizations.of(context).usernameValidatorExists;
    }
    return null;
  }

  /// saves form input to widget variable User
  void _saveInput(GlobalKey<FormState> key, bool validate) {
    if (key.currentState.validate()) {
      key.currentState.save();
    } else {
      validate = true;
    }
  }

  Widget _emailScreen() {
//    Locale thisLocale = Localizations.localeOf(context);
    _emailKey.currentState?.validate();
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
                        key: Key(AppLocalizations.of(context).emailPrompt),
                        autovalidate: _emailAutoValidate,
                        onSaved: (String email) =>
                            widget.user.email = email.trim(),
                        keyboardType: TextInputType.text,
                        validator: _validateEmail,
                        style: regFormsTextStyle,
                        decoration: formDecoration(AppLocalizations.of(context).emailPrompt),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ui.Misc.regButtonEmpty(
                        active: false,
                        text: AppLocalizations.of(context).signInButton,
                        onTap: () {
                          setState(() {
                            _path = AuthPath.LOGIN;
                          });
                          _saveInput(_emailKey, _emailAutoValidate);
                          print('current email: ' + widget.user.email);

                          if (!_isInvalidAsyncMail) _nextStep();
                        }
                      ),
                      ui.Misc.regButtonEmpty(
                        active: true,
                        text: AppLocalizations.of(context).registerButton,
                          onTap: () {
                            setState(() {
                              _path = AuthPath.REGISTER;
                            });
                            _saveInput(_emailKey, _emailAutoValidate);
                            print('current email: ' + widget.user.email);
                            _handleNext(emailKey);
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

    Widget header;

    switch (_path) {
      case AuthPath.REGISTER:
        header = _validationStack();
        break;
      case AuthPath.LOGIN:
        header = Container();
        break;
    }

    return root(
      Form(
        key: _passwordKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: header),
                    TextFormField(
                      controller: textController,
                      autovalidate: _passwordAutoValidate,
                      validator: _validatePassword,
                      keyboardType: TextInputType.text,
                      onSaved: (String password) =>
                          widget.user.password = password,
                      obscureText: true,
                      decoration: formDecoration(AppLocalizations.of(context).passwordPrompt),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ui.Misc.regButtonEmpty(
                      active: true,
                      text: AppLocalizations.of(context).nextButton,
                      onTap: () {
                        _saveInput(_passwordKey, _passwordAutoValidate);
                        print('current password: ' + widget.user.password);
                        _handleNext(passwordKey);
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
    _namesKey.currentState?.validate();
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
                  onSaved: (String name) => widget.user.firstName = name.trim(),
                  decoration: formDecoration(AppLocalizations.of(context).firstNameFieldLabel),
                ),
                TextFormField(
                  validator: _validateNames,
                  onSaved: (String name) => widget.user.lastName = name.trim(),
                  decoration: formDecoration(AppLocalizations.of(context).lastNameFieldLabel),
                ),
                TextFormField(
                  validator: _validateUsername,
                  onSaved: (String name) => widget.user.username = name.trim(),
                  decoration: formDecoration(
                    AppLocalizations.of(context).usernameFieldLabel,
                    hint: AppLocalizations.of(context).usernameFieldHint
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
                ui.Misc.regButtonEmpty(
                  active: true,
                  text: AppLocalizations.of(context).nextButton,
                  onTap: () {
                    _saveInput(_namesKey, _usernameAutoValidate);
                    _handleNext(usernameKey);
                    createUserService.createUser(widget.user);
                  }),
              ],
            ),
          )
        ],
      ),
    )));
  }

  /// wraps all screens into basic widgets -
  /// [WillPopScope] and [ModalProgressHUD]
  Widget root(Widget kid) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _isAsyncCall,
          child: Container(
            child: Center(
              child: kid,
            ),
          ),
        ),
      ),
    );
  }

  Stack _validationStack() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Card(
          shape: CircleBorder(),
          color: Colors.black12,
          child: Container(height: 150, width: 150,),),
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0, left: 10),
          child: Transform.rotate(
            angle: -math.pi/20,
            child: Icon(Icons.lock, color: Colors.deepOrange, size: 60,),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 60),
          child: Transform.rotate(
            angle: -math.pi / -60,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              elevation: 4,
              color: Colors.yellow.shade800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: darkAccent,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: darkAccent,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: darkAccent,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: darkAccent,)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 74),
          child: Transform.rotate(
            angle: math.pi / -45,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ValidationItem(
                            AppLocalizations.of(context).passWidgetEnoughChars,
                            enoughChars
                        ),
                        ui.Misc.separator(),
                        ValidationItem(
                            AppLocalizations.of(context).passWidgetUpperCase,
                            upperCase
                        ),
                        ui.Misc.separator(),
                        ValidationItem(
                            AppLocalizations.of(context).passWidgetSpecialChar,
                            specialChar
                        ),
                        ui.Misc.separator(),
                        ValidationItem(
                            AppLocalizations.of(context).passWidgetNumber,
                            number
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.scale(
                      scale: _fabScale.value,
                      child: Card(
                        shape: CircleBorder(),
                        color: darkAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  InputDecoration formDecoration(String label, {String hint}) {
    return InputDecoration(
        focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColorLight)),
        errorStyle: regErrorStyle,
        hintText: hint,
        labelText: label,
        labelStyle: regFormsHintStyle);
  }
}
