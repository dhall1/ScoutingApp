import 'package:sqflite/sqflite.dart';

/// Singleton class for managing the database
class DatabaseManager {

	/// Name of the table that holds scouting data for testing
	static const String TABLE_TESTING = "data0";

	/// Name of the table that holds scouting data for
	/// 2019's game - Destination: Deep Space
	static const String TABLE_2019 = "data2019";

	/// An instance of the database used to prevent multiple instances
	static Database _instance;

	/// Get the path to the database.
	static Future<String> get _path async {
		return (await getDatabasesPath()) + "/data.db";
	}

	/// Opens the database, or does nothing if it is already open.
	static Future<void> _start() async {
		if (_instance == null) {
			var databaseName = await _path;
			_instance = await openDatabase(databaseName, version: 1, onCreate: (Database db, int version) async {
				await db.execute('''
					CREATE TABLE $TABLE_TESTING (
						id INTEGER PRIMARY KEY,
						scoutId VARCHAR(255),
						timestamp INTEGER,
						competitionKey VARCHAR(10),
						matchType VARCHAR(2),
						matchNumber INTEGER,
						teamNumber INTEGER,
						allianceColor CHAR(1),
						teamPosition INTEGER,
						partner1 INTEGER,
						partner2 INTEGER
					)
				''');
				await db.execute('''
					CREATE TABLE $TABLE_2019 (
						id INTEGER PRIMARY KEY,
						scoutId VARCHAR(255),
						timestamp INTEGER,
						competitionKey VARCHAR(10),
						matchType VARCHAR(2),
						matchNumber INTEGER,
						teamNumber INTEGER,
						allianceColor CHAR(1),
						teamPosition INTEGER,
						partner1 INTEGER,
						partner2 INTEGER,
						sandstormStartingLevel INTEGER,
						sandstormPlatformSuccess INTEGER,
						hatchesOnRocket INTEGER,
						cargoInRocket INTEGER,
						hatchesOnCargoShip INTEGER,
						cargoInCargoShip INTEGER,
						endgamePlatformLevel INTEGER,
						dockingRP INTEGER,
						rocketRP INTEGER,
						winStatus CHAR(1)
					)
				''');
			});
		}
	}

	/// Closes the database
	static Future<void> close() async {
		if (_instance != null) {
			await _instance.close();
			_instance = null;
		}
	}

	/// Delete the entire database.
	///
	/// This action is not reversible.
	static Future<void> delete() async {
		await close();
		await deleteDatabase(await _path);
	}

	/// Delete the data with an id of [id] for the given [year].
	///
	/// Because only the testing database exists thus far, [year] does not affect
	/// the result.
	static Future<int> deleteSavedData(int year, int id) async {
		await _start();
		switch (year) {
			case 2019:
				return _instance.delete(TABLE_2019, where: "id = ?", whereArgs: [id]);
			default:
				return _instance.delete(TABLE_TESTING, where: "id = ?", whereArgs: [id]);
		}
	}

	/// Saved the data given in [map] for the given [year].
	///
	/// Because only the testing database exists thus far, [year] does not affect
	/// the result.
	static Future<int> saveMatchData(Map<String, dynamic> map, int year) async {
		await _start();
		switch (year) {
			case 2019:
				return _instance.insert(TABLE_2019, map);
			default:
				return _instance.insert(TABLE_TESTING, map);
		}
	}

	/// Load the saved matches for a given [year].
	///
	/// Because only the testing database exists thus far, [year] does not affect
	/// the result.
	static Future<List<Map<String, dynamic>>> loadSavedMatches(int year) async {
		await _start();
		switch (year) {
			case 2019:
				return _instance.query(TABLE_2019);
			default:
				return _instance.query(TABLE_TESTING);
		}
	}

}