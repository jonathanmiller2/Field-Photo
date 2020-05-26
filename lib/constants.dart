library constants;

const String EOMF_SITE_USERNAME_TAKEN_MESSAGE = "A user with that username already exists";
const String EOMF_SITE_EMAIL_TAKEN_MESSAGE = "This email address is already in use";
const String EOMF_URL = "http://eomf.ou.edu/";
const String LOGIN_URL = "http://eomf.ou.edu/accounts/mobile_login/";
const String LOGOUT_URL = "http://eomf.ou.edu/accounts/logout";
const String REGISTER_URL = "http://eomf.ou.edu/accounts/register/";
const String UPLOAD_URL = "http://eomf.ou.edu/photos/mobile/upload3/";
const String ID_FROM_USERNAME_URL = "http://eomf.ou.edu/accounts/id_from_username/?username=";

//TODO: It would be far better to request this from the EOMF API
//TODO: Update this any time the field cover category numbers change! This should always match the EOMF categories defined by the categories section of the admin site, and the category table in the database
const Map<int, String> landcoverClassMap =
{0: 'Unclassified',
	1:'Evergreen Needleleaf Forest',
	2:'Evergreen Broadleaf Forest',
	3:'Deciduous Needleleaf Forest',
	4:'Deciduous Broadleaf Forest',
	5:'Mixed Forest',
	6:'Closed Shrublands',
	7:'Open Shrublands',
	8:'Woody Savannas',
	9:'Savannas',
	10:'Grasslands',
	11:'Permanent Wetlands',
	12:'Croplands',
	13:'Urban and Built-Up',
	14:'Cropland/Natural Vegetation Mosaic',
	15:'Snow and Ice',
	16:'Barren or Sparsely Vegetated',
	17:'Water Body',};