import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:tutor/data/constants.dart';

import 'package:tutor/l10n/messages_all.dart';


class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appName {
    return Intl.message('Tutor',
      name: 'appName',
      desc: 'name of the app'
    );
  }

  String get emailPrompt {
    return Intl.message('Your email address',
        name: 'emailPrompt',
        desc: 'Label text for registration screen, email'
    );
  }

  String get passwordPrompt {
    return Intl.message('Your password',
        name: 'passwordPrompt',
        desc: 'Label text for registration screen, password'
    );
  }

  String get passwordPromptAgain {
    return Intl.message('Your password again, to verify',
        name: 'passwordPromptAgain',
        desc: 'Label text for registration screen, password'
    );
  }

  String get nextButton {
    return Intl.message('Next',
        name: 'nextButton',
        desc: 'Text on the Next button, email registration screen'
    );
  }

  String get emailValidator {
    return Intl.message('Let\'s use a valid email, please',
        name: 'emailValidator',
        desc: 'Email validation error message for registration'
    );
  }

  String get emailValidatorExists {
    return Intl.message('It seems a user with this email already exists. Log in?',
        name: 'emailValidatorExists',
        desc: 'Email validation error message for registration'
    );
  }

  String get emailValidatorUnknown {
    return Intl.message('We don\'t know this email. Register?',
        name: 'emailValidatorUnknown',
        desc: 'Email validation error message for registration'
    );
  }

  String get passwordValidator {
    return Intl.message('Let\'s use a valid password, please',
        name: 'passwordValidator',
        desc: 'Password validation error message for registration'
    );
  }

  String get usernameValidatorLength {
    return Intl.message('Username must be over $credentialMinLength characters',
        name: 'usernameValidatorLength',
        desc: 'Username validation error message for registration'
    );
  }

  String get usernameValidatorExists {
    return Intl.message('It seems a user with this username already exists',
        name: 'usernameValidatorExists',
        desc: 'Username validation error message for registration'
    );
  }

  String get passwordValidatorAlpha {
    return Intl.message('Password must contain digits',
        name: 'passwordValidatorAlpha',
        desc: 'Password validation error message for registration'
    );
  }

  String get firstNameFieldLabel {
    return Intl.message('Your first name here',
        name: 'firstNameFieldLabel',
        desc: 'Label text for registation'
    );
  }

  String get lastNameFieldLabel {
    return Intl.message('Your last name here',
        name: 'lastNameFieldLabel',
        desc: 'Label text for registation'
    );
  }

  String get usernameFieldLabel {
    return Intl.message('Your username',
        name: 'usernameFieldLabel',
        desc: 'Label text for registation'
    );
  }

  String get usernameFieldHint {
    return Intl.message('It will make your account unique',
        name: 'usernameFieldHint',
        desc: 'Hint text for registation'
    );
  }

  String get nameValidatorEmpty {
    return Intl.message('We need a name!',
        name: 'nameValidatorEmpty',
        desc: 'Reminder if registration name field is empty'
    );
  }

  String get nameScreenWarning {
    return Intl.message('Ok, almost there!',
        name: 'nameScreenWarning',
        desc: 'Begins the names screen in registration'
    );
  }

  String get passWidgetEnoughChars {
    return Intl.message('$credentialMinLength characters',
        name: 'passWidgetEnoughChars',
        desc: 'Password screen validator widget'
    );
  }

  String get passWidgetSpecialChar {
    var plural = specialCharMinLength == 1 ? '' : 's';
    return Intl.message('$specialCharMinLength special character' + plural,
        name: 'passWidgetSpecialChar',
        desc: 'Password screen validator widget'
    );
  }

  String get passWidgetUpperCase {
    var plural = upperCaseMinLength == 1 ? '' : 's';
    return Intl.message('$upperCaseMinLength upper case character' + plural,
        name: 'passWidgetUpperCase',
        desc: 'Password screen validator widget'
    );
  }

  String get passWidgetNumber {
    var plural = numberMinLength == 1 ? '' : 's';
    return Intl.message('$numberMinLength number' + plural,
        name: 'passWidgetNumber',
        desc: 'Password screen validator widget'
    );
  }

  String get signInButton {
    return Intl.message('Sign in',
        name: 'signInButton',
        desc: 'Button label on auth screen'
    );
  }

  String get registerButton {
    return Intl.message('Register',
        name: 'registerButton',
        desc: 'Button label on auth screen'
    );
  }

  String get logoutButton {
    return Intl.message('Log out',
        name: 'logoutButton',
        desc: 'Button label on auth screen'
    );
  }

  String get lives {
    return Intl.message('Lives:',
        name: 'lives',
        desc: 'Profile page, text widget telling where the user lives'
    );
  }

  String get livesError {
    return Intl.message('Not really clear where this person lives',
        name: 'livesError',
        desc: 'Profile page, text widget telling where the user lives, error message'
    );
  }

  String get memberSince {
    return Intl.message('Member since',
        name: 'memberSince',
        desc: 'Profile page, text widget telling when the user joined'
    );
  }
}


class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

//flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/locale/locales.dart
//this creates arb file in l10n dir

//flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_en.arb lib/l10n/intl_ru.arb lib/l10n/intl_messages.arb lib/locale/locales.dart

