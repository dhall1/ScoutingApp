import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'scouting_drawer.dart';
import '../util/tba_helper.dart' as TBAHelper;

class _CompetitionData {

	final String name;
	final String key;

	_CompetitionData(this.name, this.key);

}

class CompetitionSelection extends StatefulWidget {

	final int year;

	CompetitionSelection(this.year);

	@override
	_CompetitionSelectionState createState() => _CompetitionSelectionState();

}

class _CompetitionSelectionState extends State<CompetitionSelection> {

	Future<Map<String, List<_CompetitionData>>> _future;
	bool _isSaving;

	@override
	void initState() {
		super.initState();
		_isSaving = false;
		_future = _loadCompetitionData();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: _createAppBar(),
			drawer: ScoutingAppDrawer(),
			body: Stack(
				children: _createBody(),
			),
		);
	}

	Future<Map<String, List<_CompetitionData>>> _loadCompetitionData() async {
		var competitions = Map<String, List<_CompetitionData>>();
		List<dynamic> data = await TBAHelper.fetchFromTBA("/events/${widget.year}");
		data.forEach((event) {
			// See https://github.com/the-blue-alliance/the-blue-alliance/blob/master/consts/event_type.py#L2
			switch (event["event_type"]) {
				case 0: // Regionals
					var country = event["country"];
					var displayName = "$country Regionals";
					competitions.putIfAbsent(displayName, () => <_CompetitionData>[])
						..add(_CompetitionData(event["name"], event["key"]));
					break;
				case 1: // District Events -- skip to next
				case 2: // District Championships
					var district = event["district"];
					var displayName = district["display_name"];
					competitions.putIfAbsent(displayName, () => <_CompetitionData>[])
						..add(_CompetitionData(event["name"], event["key"]));
					break;
				case 3: // Championship Divisions -- skip to next
				case 4: // Championship Finals
					var displayName = "";
					if (event["state_prov"] == 'TX') {
						displayName = "Houston Championships";
					} else {
						displayName = "Detroit Championships";

					}
					competitions.putIfAbsent(displayName, () => <_CompetitionData>[])
						..add(_CompetitionData(event["name"], event["key"]));
					break;
				case 99: // Offseasons
					var displayName = "Offseason";
					competitions.putIfAbsent(displayName, () => <_CompetitionData>[])
						..add(_CompetitionData(event["name"], event["key"]));
					break;
				case 100: // Preseasons
					var displayName = "Preseason";
					competitions.putIfAbsent(displayName, () => <_CompetitionData>[])
						..add(_CompetitionData(event["name"], event["key"]));
					break;
				default:
			}
		});
		return competitions;
	}

	Widget _createAppBar() {
		return AppBar(
			title: Text("Competitions"),
			actions: <Widget>[
				IconButton(
					icon: Icon(Icons.help_outline),
					onPressed: () {
						showDialog(
							context: context,
							builder: (BuildContext context) {
								return AlertDialog(
									title: Text("Competition Selection"),
									content: Text("To select a competition, long press on the competition you wish to choose and follow the prompt."),
									actions: <Widget>[
										FlatButton(child: Text("Dismiss"), onPressed: () => Navigator.pop(context))
									],
								);
							}
						);
					},
				)
			],
		);
	}

	List<Widget> _createBody() {
		FutureBuilder mainBody = FutureBuilder<Map<String, List<_CompetitionData>>>(
			future: _future,
			builder: (BuildContext context, AsyncSnapshot<Map<String, List<_CompetitionData>>> snapshot) {
				if (!snapshot.hasData) {
					return Center(
						child: Padding(
							padding: EdgeInsets.all(16.0),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									Text("Loading competitions. If this message persists for more than 5 seconds, please check your internet connection and try again")
								],
							)
						)
					);
				} else {
					var data = snapshot.data;
					return ListView(
						children: data.keys.map((String key) {
							return ExpansionTile(
								title: Text(key),
								children: data[key].map((_CompetitionData competitionData) {
									return ListTile(
										title: Text(competitionData.name),
										subtitle: Text(competitionData.key),
										onLongPress: () {
											showDialog(
												context: context,
												builder: (BuildContext ctx) {
													return AlertDialog(
														title: Text("Set ${competitionData.key} as current event?"),
														content: Text("This will set ${competitionData.name} as the event you are currently attending"),
														actions: <Widget>[
															FlatButton(
																child: Text("Cancel"),
																onPressed: () => Navigator.pop(ctx)
															),
															FlatButton(
																child: Text("Confirm"),
																onPressed: () {
																	setState(() {
																		Navigator.pop(ctx);
																		setState(() {
																			_isSaving = true;
																		});
																		SharedPreferences.getInstance().then((preferences) {
																			preferences.setString("currentCompKey", competitionData.key).then((_) {
																				preferences.setString("currentCompName", competitionData.name).then((_) {
																					Navigator.pop(context);
																				});
																			});
																		});
																	});
																}
															)
														],
													);
												}
											);
										},
									);
								}).toList(),
							);
						}).toList()
					);
				}
			},
		);
		var stackChildren = <Widget>[
			mainBody
		];
		if (_isSaving) {
			stackChildren.add(Stack(
				children: <Widget>[
					Opacity(
						opacity: 0.4,
						child: const ModalBarrier(dismissible: false, color: Colors.grey,),
					),
					Center(
						child: CircularProgressIndicator()
					)
				],
			));
		}
		return stackChildren;
	}

}