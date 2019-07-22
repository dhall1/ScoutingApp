import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../scouting_drawer.dart';
import '../../util/database_manager.dart';
import '../../util/sync_manager.dart';
import '../../util/settings.dart';
import 'list_tile_generators.dart';


class SavedMatches extends StatefulWidget {

	final int year;

	SavedMatches(this.year);

	@override
	_SavedMatchesState createState() => _SavedMatchesState();

}

class _SavedMatchesState extends State<SavedMatches> {

	/// The future holding all currently saved matches
	Future<List<Map<String, dynamic>>> _data;

	@override
	void initState() {
		super.initState();
		_data = DatabaseManager.loadSavedMatches(widget.year);
	}

	void _refreshData() {
		setState(() {
			_data = DatabaseManager.loadSavedMatches(widget.year);
		});
	}

	/// Callback when the sync button is pressed.
	void _onSync() async {
		var connectivity = await (new Connectivity()).checkConnectivity();
		switch (connectivity) {
			case ConnectivityResult.none:
				showDialog(
					context: this.context,
					builder: (BuildContext ctx) {
						return AlertDialog(
							title: Text("No Connection!"),
							content: Text(
								"You are currently not connected to a network. Please check your settings and try again",
							),
							actions: <Widget>[
								FlatButton(
									child: Text("Close"),
									onPressed: () => Navigator.pop(ctx),
								)
							],
						);
					}
				);
				break;
			case ConnectivityResult.mobile:
				SharedPreferences preferences = await SharedPreferences.getInstance();
				if (!(preferences.getBool(SETTING_KEY_SYNC_ON_DATA) ?? false)) {
					showDialog(
						context: this.context,
						builder: (BuildContext ctx) {
							return AlertDialog(
								title: Text("No Syncing on Mobile Data"),
								content: Text(
									"Your settings do not allow syncing on mobile data. If you wish to sync on mobile data, please uncheck this setting in the settings menu and try again",
								),
								actions: <Widget>[
									FlatButton(
										child: Text("Close"),
										onPressed: () => Navigator.pop(ctx),
									)
								],
							);
						}
					);
					break;
				}
				continue wifi;
			wifi:
			default:
				showDialog(
					context: this.context,
					builder: (BuildContext ctx) {
						return AlertDialog(
							title: Text("Sync?"),
							content: Text(
								"All data will be synced to the server. Do you want to continue?",
								softWrap: true,
							),
							actions: <Widget>[
								FlatButton(
									child: Text("Close"),
									onPressed: () {
										Navigator.pop(ctx);
									},
								),
								FlatButton(
									child: Text("Confirm"),
									onPressed: () {
										Navigator.pop(ctx);
										SyncManager.syncAll(widget.year).then((successful) {
											_refreshData();
										});
									}
								)
							],
						);
					}
				);
		}
	}

	/// Callback when the delete button is pressed.
	///
	/// Deletes the save file when the Delete icon is pressed.
	void _onDelete() {
		showDialog(
			context: this.context,
			builder: (BuildContext ctx) {
				return AlertDialog(
					title: Text("Delete all Entries?"),
					content: Text(
						"Deleting all entries will permanently delete data for all matches currently saved. Are you sure you want delete all entries?",
						softWrap: true,
					),
					actions: <Widget>[
						FlatButton(
							child: Text("Close"),
							onPressed: () {
								Navigator.pop(ctx);
							},
						),
						FlatButton(
							child: Text("Confirm"),
							onPressed: () {
								Navigator.pop(ctx);
								DatabaseManager.delete().then((_) {
									_refreshData();
								});
							},
						)
					],
				);
			}
		);
	}

	/// Create the AppBar
	Widget _appBar() {
		return AppBar(
			title: Text("Saves for ${widget.year}"),
			actions: <Widget>[
				IconButton(
					icon: Icon(Icons.help_outline),
					onPressed: () {
						showDialog(context: context, builder: (context) => AlertDialog(
							title: Text("Saved Matches Help"),
							content: Text(
								"Use the menu at the top to refresh the page, sync data to the server, or delete all saves. "
								"If you wish to delete individual saves, press and hold on a match."
							),
							actions: <Widget>[FlatButton(child: Text("Dismiss"), onPressed: () => Navigator.pop(context))]
						));
					},
				),
				PopupMenuButton<String>(
					onSelected: (v) {
						if (v == "d") {
							_onDelete();
						} else if (v == "s") {
							_onSync();
						} else {
							_refreshData();
						}
					},
					itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
						PopupMenuItem<String>(
							value: "r",
							child: Text("Refresh Page")
						),
						PopupMenuItem<String>(
							value: "s",
							child: Text("Sync")
						),
						PopupMenuItem<String>(
							value: "d",
							child: Text("Delete All")
						)
					],
				)
			],
		);
	}

	/// Create the body
	Widget _body() {
		return FutureBuilder(
			future: _data,
			builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
				if (!snapshot.hasData) {
					return Center(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								Text("Loading Data")
							],
						)
					);
				} else {
					var data = snapshot.data;
					if (data.length == 0) {
						return Center(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									Text("No Data is Saved")
								],
							)
						);
					}
					return ListView(
						children: data.map<Widget>((matchData) {
							return ListTile(
								title: Text(
									"Match ${matchData["matchNumber"]}: Team ${matchData["teamNumber"]} (${matchData["allianceColor"] == "b" ? "Blue" : "Red"} ${matchData["teamPosition"]})"
								),
								subtitle: Text(
									widget.year == 2019 ? generate2019Subtitle(matchData) : generateTestSubtitle(matchData)
								),
								onLongPress: () {
									showDialog(
										context: context,
										builder: (ctx) {
											return AlertDialog(
												title: Text("Delete Save?"),
												content: Text("This will permanently delete this save. Are you sure you want to delete it?"),
												actions: <Widget>[
													FlatButton(
														child: Text("Close"),
														onPressed: () {
															Navigator.pop(ctx);
														},
													),
													FlatButton(
														child: Text("Confirm"),
														onPressed: () {
															Navigator.pop(ctx);
															DatabaseManager.deleteSavedData(widget.year, matchData["id"]).then((count) {
																_refreshData();
															});
														},
													)
												],
											);
										}
									);
								},
							);
						}).toList()
					);
				}
			},
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: _appBar(),
			drawer: ScoutingAppDrawer(),
			body: _body()
		);
	}

}