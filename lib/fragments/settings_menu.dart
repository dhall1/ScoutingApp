import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/settings.dart';
import 'scouting_drawer.dart';

/// Settings Menu Widget
class SettingsMenu extends StatefulWidget {

	@override
	_SettingsMenuState createState() => _SettingsMenuState();

}

/// Settings Menu State
class _SettingsMenuState extends State<SettingsMenu> {

	/// Should the app attempt to sync on data?
	bool _syncOnData = false;

	/// Loads any previously saved messages from SharedPreferences
	Future<void> _loadPreferences() async {
		bool sync = (await SharedPreferences.getInstance()).getBool(
			SETTING_KEY_SYNC_ON_DATA) ?? SETTING_DEFAULT_SYNC_ON_DATA;
		setState(() {
			_syncOnData = sync;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Settings"),
			),
			drawer: ScoutingAppDrawer(),
			body: FutureBuilder(
				future: _loadPreferences(),
				builder: (BuildContext context, AsyncSnapshot snapshot) {
					return ListView(
						children: <Widget>[
							ListTile(
								title: Text("Allow Sync on Mobile Data"),
								subtitle: Text("Standard data rates may apply"),
								trailing: Checkbox(
									value: _syncOnData,
									onChanged: (bool value) async {
										SharedPreferences preferences = await SharedPreferences
											.getInstance();
										preferences.setBool(
											SETTING_KEY_SYNC_ON_DATA, value);
										setState(() {
											_syncOnData = value;
										});
									}
								),
							)
						],
					);
				}
			),
		);
	}

}