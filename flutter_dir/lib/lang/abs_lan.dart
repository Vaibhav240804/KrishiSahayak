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

  String get cropDisease;

  String get apple;
  String get cherry;
  String get corn;
  String get grape;
  String get peach;
  String get pepper;
  String get potato;
  String get strawberry;
  String get tomato;

  String get appleAppleScab;
  String get appleBlackRot;
  String get appleCedarAppleRust;
  String get appleHealthy;
  String get cherryPowderyMildew;
  String get cherryHealthy;
  String get cornCercosporaLeafSpot;
  String get cornCommonRust;
  String get cornNorthernLeafBlight;
  String get cornHealthy;
  String get grapeBlackRot;
  String get grapeEscaBlackMeasles;
  String get grapeLeafBlight;
  String get grapeHealthy;
  String get peachBacterialSpot;
  String get peachHealthy;
  String get bellPepperBacterialSpot;
  String get bellPepperHealthy;
  String get potatoEarlyBlight;
  String get potatoLateBlight;
  String get potatoHealthy;
  String get strawberryLeafScorch;
  String get strawberryHealthy;
  String get tomatoBacterialSpot;
  String get tomatoEarlyBlight;
  String get tomatoLateBlight;
  String get tomatoLeafMold;
  String get tomatoSeptoriaLeafSpot;
  String get tomatoSpiderMites;
  String get tomatoTargetSpot;
  String get tomatoYellowLeafCurlVirus;
  String get tomatoMosaicVirus;
  String get tomatoHealthy;

  static languagesList() {}

  getLabel(Locale locale) {}
}
