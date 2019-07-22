import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'database_manager.dart';

/// Singleton class for managing syncing operations.
class SyncManager {

	/// Syncs all data for the given [year] with the server.
	static Future<bool> syncAll(int year) async {
		for (var save in await DatabaseManager.loadSavedMatches(year)) {
			var response = await http.post(
				"https://frcscoutingapp.dhallsprojects.com/api/submit/$year",
				headers: {
					'Scouting-Key': '',
					'Content-Type': 'application/json'
				},
				body: jsonEncode(save)
			);
			if (response.statusCode == HttpStatus.ok) {
				var returnedData = jsonDecode(response.body);
				if (returnedData["status"] == "failure") {
					return false;
				} else {
					await DatabaseManager.deleteSavedData(year, save["id"]);
				}
			} else {
				return false;
			}
		}
		return true;
	}

}