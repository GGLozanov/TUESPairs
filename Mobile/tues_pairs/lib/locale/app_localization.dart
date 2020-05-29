import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tues_pairs/locale/application.dart';

class AppLocalizations {

  AppLocalizations(Locale locale) {
    this.locale = locale;
    _localizedStrings = null;
  }
  
  Locale locale;
  static Map<dynamic, dynamic> _localizedStrings;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String translate(String key) {
    return _localizedStrings[key] ?? '$key not found';
  }

  static Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = new AppLocalizations(locale);
    String jsonString = await rootBundle.loadString('lang/${locale.languageCode}.json');
    _localizedStrings = json.decode(jsonString);

    return appLocalizations;
  }

  get currentLanguage => locale.languageCode;

  
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => applic.supportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

}

class SpecificAppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale overriddenLocale;

  const SpecificAppLocalizationsDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(overriddenLocale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => true;
}