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

  String get passwordValidatorLength {
    return Intl.message('Password must be over $passwordMinLength characters',
        name: 'passwordValidatorLength',
        desc: 'Password validation error message for registration'
    );
  }

  String get passwordValidatorAlpha {
    return Intl.message('Password must contain digits',
        name: 'passwordValidatorAlpha',
        desc: 'Password validation error message for registration'
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

