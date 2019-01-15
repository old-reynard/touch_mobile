import 'package:flutter/material.dart';

const String none           = 'None';
const String idKey          = 'id';
const String userIdKey      = 'user_id';
const String activeKey      = 'active';
const String staffKey       = 'staff';
const String adminKey       = 'admin';
const String createdAtKey   = 'created_at';
const String confirmedKey   = 'confirmed';
const String confirmedAtKey = 'confirmed_at';
const String latitudeKey    = 'latitude';
const String longitudeKey   = 'longitude';
const String positionKey    = 'position';
const String biographyKey   = 'biography';
const String finderKey      = 'finder';
const String emailKey       = 'email';
const String firstNameKey   = 'first_name';
const String lastNameKey    = 'last_name';
const String passwordKey    = 'password';
const String usernameKey    = 'username';
const String resourceUriKey = 'resource_uri';

const String baseApiUrl = 'http://45.33.98.155:8000/api/';

const jsonHeader = {"Content-Type": "application/json"};

const int credentialMinLength   = 8;
const int specialCharMinLength  = 1;
const int upperCaseMinLength    = 1;
const int numberMinLength       = 1;

const Pattern emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

const Pattern alphaRegex = '[a-zA-Z]';

// the theme that will be used for the whole app
ThemeData appTheme = ThemeData(
  primarySwatch: Colors.orange,
  fontFamily: 'Lato',
  primaryColorDark: primaryColorDark,
  accentColor: accentColor,
  primaryColorLight: primaryColorLight,
  primaryColor: primaryColor,
  dividerColor: dividerColor,
  errorColor: darkAccent,
);

// styles
/// used for styling text in registration text forms
const TextStyle regFormsTextStyle = TextStyle(
  fontSize: 22, color: Colors.black, fontFamily: 'Lato'
);

const TextStyle regFormsHintStyle = TextStyle(
    fontSize: 20, fontFamily: 'Lato'
);

const TextStyle regErrorStyle = TextStyle(
    color: darkAccent
);

const TextStyle regButtonStyle = TextStyle(
    color: darkAccent, fontSize: 20, fontWeight: FontWeight.normal
);


// colors
const Color regButtonColor = Color(0xFF2364ef);
const Color darkAccent = Color(0xFF0D47A1);
const Color primaryColorDark = Color(0xFFE64A19);
const Color accentColor = Color(0xFF009688);
const Color primaryColorLight = Color(0xFFFFCCBC);
const Color primaryColor = Color(0xFFFF5722);
const Color dividerColor = Color(0xFFBDBDBD);
const Color primaryTextColor = Color(0xFF212121);
const Color secondaryColorDark = Color(0xFF757575);
const Color iconsColor = Color(0xFFFFFFFF);
