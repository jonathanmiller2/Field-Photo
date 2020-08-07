library constants;

import 'package:flutter/cupertino.dart';

import 'localizations.dart';

const String EOMF_SITE_USERNAME_TAKEN_MESSAGE = "A user with that username already exists";
const String EOMF_SITE_EMAIL_TAKEN_MESSAGE = "This email address is already in use";
const String EOMF_INVALID_EMAIL_MESSAGE = "Enter a valid email address";

const String LOGIN_URL = "http://eomf.ou.edu/accounts/mobile_login/";
const String LOGOUT_URL = "http://eomf.ou.edu/accounts/logout";
const String REGISTER_URL = "http://eomf.ou.edu/accounts/register/";
const String UPLOAD_URL = "http://eomf.ou.edu/photos/mobile/upload3/";

//If adding a language, update both the locale and language lists below
const List<String> SUPPORTED_LANGUAGES = ['en', 'zh', 'pt', 'es', 'fr'];
const List<Locale> SUPPORTED_LOCALES = [
	const Locale('en'),
	const Locale('zh'),
	const Locale('pt'),
	const Locale('es'),
	const Locale('fr'),
];

//TODO: It would be far better to request this from the EOMF API
//TODO: Update this any time the field cover category numbers change! This should always match the EOMF categories defined by the categories section of the admin site, and the category table in the database

class LandcoverMap {
	Map<int, String> getLandcoverClassMap(BuildContext context) {
		return {
			0: AppLocalizations.of(context).translate('Unclassified'),
			1: AppLocalizations.of(context).translate('Evergreen Needleleaf Forest'),
			2: AppLocalizations.of(context).translate('Evergreen Broadleaf Forest'),
			3: AppLocalizations.of(context).translate('Deciduous Needleleaf Forest'),
			4: AppLocalizations.of(context).translate('Deciduous Broadleaf Forest'),
			5: AppLocalizations.of(context).translate('Mixed Forest'),
			6: AppLocalizations.of(context).translate('Closed Shrublands'),
			7: AppLocalizations.of(context).translate('Open Shrublands'),
			8: AppLocalizations.of(context).translate('Woody Savannas'),
			9: AppLocalizations.of(context).translate('Savannas'),
			10: AppLocalizations.of(context).translate('Grasslands'),
			11: AppLocalizations.of(context).translate('Permanent Wetlands'),
			12: AppLocalizations.of(context).translate('Croplands'),
			13: AppLocalizations.of(context).translate('Urban and Built-Up'),
			14: AppLocalizations.of(context).translate('Cropland/Natural Vegetation Mosaic'),
			15: AppLocalizations.of(context).translate('Snow and Ice'),
			16: AppLocalizations.of(context).translate('Barren or Sparsely Vegetated'),
			17: AppLocalizations.of(context).translate('Water Body'),
		};
	}
	
}