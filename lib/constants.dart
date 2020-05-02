
library constants;

const String EOMF_URL = "http://eomf.ou.edu/";
const String LOGIN_URL = "http://eomf.ou.edu/accounts/login/";
const String REGISTER_URL = "http://eomf.ou.edu/accounts/register/";
const String UPLOAD_URL = "http://eomf.ou.edu/photos/mobile/upload2/";


//TODO: REQUEST THIS FROM THE EOMF API!!!!!
const Map<int, String> landcoverClassMap =
{0: 'Unclassified',
	1:'Evergreen Needleleaf Forest',
	2:'Evergreen Broadleaf Forest',
	3:'Deciduous Needleleaf Forest',
	4:'Deciduous broadleaf Forest',
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