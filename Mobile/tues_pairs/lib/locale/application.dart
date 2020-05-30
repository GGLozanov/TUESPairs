import 'package:flutter/cupertino.dart';

import '../main.dart';

typedef void LocaleChangeCallback(Locale locale);

class APPLIC {
  final List<String> supportedLanguages = ['en', 'bg'];
  
  Iterable<Locale> supportedLocales() => supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  LocaleChangeCallback onLocaleChanged;

  static final APPLIC _applic = new APPLIC._internal();

  factory APPLIC() {
    return _applic;
  }
   
  APPLIC._internal();

  void changeLanguage(String language) {
    if (language == 'English') {
      onLocaleChanged(new Locale('en', ''));
    } else if (language == "Български") {
      onLocaleChanged(new Locale('bg', ''));
    }
  }

}

APPLIC applic = new APPLIC();