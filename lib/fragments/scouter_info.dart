import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as URLLauncher;

import '../util/settings.dart';
import 'scouting_drawer.dart';

class ScouterInfoMenu extends StatefulWidget {

	@override
	_ScouterInfoMenuState createState() => _ScouterInfoMenuState();

}

class _ScouterInfoMenuState extends State<ScouterInfoMenu> {

	bool _isSaving;
	Future<List<String>> _data;
	TextEditingController _controller;

	@override
	void initState() {
		super.initState();
		_isSaving = false;
		_data = _fetchData();
		_controller = TextEditingController();
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Scouter Info")
			),
			drawer: ScoutingAppDrawer(),
			body: _createBody()
		);
	}

	Widget _createBody() {
		return FutureBuilder<List<String>>(
			future: _data,
			builder: (BuildContext ctx, AsyncSnapshot<List<String>> snapshot) {
				if (!snapshot.hasData) {
					return Center(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								Text("Loading scouter info...")
							],
						),
					);
				} else {
					_controller.text = snapshot.data[0];
					return Padding(
						padding: EdgeInsets.all(16.0),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								ListTile(
									leading: Icon(
										Icons.info_outline,
										color: Colors.red,
									),
									title: Text("Please ensure the following information is filled out")
								),
								Divider(color: Colors.black),
								Padding(
									padding: EdgeInsets.only(bottom: 20.0),
									child: Row(
										children: <Widget>[
											Expanded(
												child: TextField(
													controller: _controller,
													enabled: !_isSaving,
													textCapitalization: TextCapitalization.words,
													decoration: InputDecoration(
														border: OutlineInputBorder(),
														labelText: "Scouter Name"
													)
												)
											),
											FlatButton(
												child: Text(
													_isSaving ? "Saving..." : "Save",
													style: TextStyle(
														color: _isSaving ? Colors.black : Colors.green
													),
												),
												onPressed: () async {
													var name = _controller.text;
													if (name == "") {
														return;
													}
													setState(() {
														_isSaving = true;
													});
													SharedPreferences preferences = await SharedPreferences.getInstance();
													await preferences.setString(SETTING_KEY_SCOUT_NAME, name);
													_data = _fetchData();
													setState(() {
														_isSaving = false;
													});
												},
											)
										],
									)
								),
								Text(
									"Current Competition",
									style: Theme.of(context).primaryTextTheme.caption,
								),
								Row(
									children: <Widget>[
										Expanded(
											child: Text(
												snapshot.data[1],
												overflow: TextOverflow.fade,
											)
										),
										IconButton(
											icon: Icon(
												Icons.edit,
												semanticLabel: "Edit Current Competition",
											),
											onPressed: () {
												if (!_isSaving) {
													Navigator.pushNamed(context, "/scouter_info/comp_selection").then((_) {
														_data = _fetchData();
													});
												}
											},
										)
									],
								),
								Divider(color: Colors.black),
								ListTile(
									subtitle: RichText(
										text: TextSpan(
											style: Theme.of(context).textTheme.subtitle,
											children: <TextSpan>[
												TextSpan(text: "You can view the submitted scouting data at "),
												TextSpan(
													text: "https://frcscoutingapp.dhallsprojects.com",
													recognizer: TapGestureRecognizer()
														..onTap = () {
															URLLauncher.launch("https://frcscoutingapp.dhallsprojects.com");
														}
												),
												TextSpan(text: ".")
											]
										),
									),
								)
							],
						),
					);
				}
			},
		);
	}

	Future<List<String>> _fetchData() async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		return <String>[
			preferences.get(SETTING_KEY_SCOUT_NAME) ?? SETTING_DEFAULT_SCOUT_NAME,
			preferences.get(SETTING_KEY_CURRENT_COMP_NAME) ?? SETTING_DEFAULT_CURRENT_COMP_NAME
		];
	}

}