import 'package:shared_preferences/shared_preferences.dart';

const String SETTING_KEY_SYNC_ON_DATA = "syncOnData";
const String SETTING_KEY_SCOUT_NAME = "name";
const String SETTING_KEY_CURRENT_COMP_NAME = "currentCompName";
const String SETTING_KEY_CURRENT_COMP_KEY = "currentCompKey";


const bool SETTING_DEFAULT_SYNC_ON_DATA = false;
const String SETTING_DEFAULT_SCOUT_NAME = "No name";
const String SETTING_DEFAULT_CURRENT_COMP_NAME = "No competition";
const String SETTING_DEFAULT_CURRENT_COMP_KEY = "noKey";

Future<dynamic> loadSetting(String key, dynamic defaultValue) async {
	SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
	return sharedPreferences.get(key) ?? defaultValue;
}

Future<void> setString(String key, String value) async {
	SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
	await sharedPreferences.setString(key, value);
}

Future<void> setBoolean(String key, bool value) async {
	SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
	await sharedPreferences.setBool(key, value);
}