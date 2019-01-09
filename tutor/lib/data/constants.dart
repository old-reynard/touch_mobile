import 'package:flutter/material.dart';

const String emailKey = 'email';
const String firstNameKey = 'first_name';
const String lastNameKey = 'last_name';
const String passwordKey = 'password';
const String usernameKey = 'username';
const String baseApiUrl = 'http://45.33.98.155:8000/api/';

const jsonHeader = {"Content-Type": "application/json"};


const int passwordMinLength = 8;

const Pattern emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

const Pattern alphaRegex = '[a-zA-Z]';
//const Pattern digitRegex = r'\d';

// the theme that will be used for the whole app
ThemeData appTheme = ThemeData(
  primarySwatch: Colors.orange,
  fontFamily: 'Lato',
);

// styles

/// used for styling text in registration text forms
const TextStyle regFormsTextStyle = TextStyle(
  fontSize: 22, color: Colors.black, fontFamily: 'Lato'
);

const TextStyle regFormsHintStyle = TextStyle(
    fontSize: 20, fontFamily: 'Lato'
);


// colors
const Color regButtonColor = Color(0xFF2364ef);
