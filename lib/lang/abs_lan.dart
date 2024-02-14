import 'package:flutter/cupertino.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get home;

  String get marketsNearby;

  String get labelSelectLanguage;

  String get weatherSoil;

  String get personalCal;

  String get profile;

  String get name;

  String get email;

  String get location;

  String get soilAnalysis;

  String get lastUpdatedDate;

  String get save;

  String get cancel;

  String get password;

  String get signup;

  String get login;


  static languagesList() {}

  getLabel(Locale locale) {}
}
