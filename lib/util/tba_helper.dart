import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

/// The base URL for the TBA API
const _BASE_URL = "https://www.thebluealliance.com/api/v3";

/// Fetches data from thebluealliance.
///
/// This makes a request to the TBA API at the given [endpoint]. This adds the
/// required X-TBA-Auth-Key header and returns the body of the response, which
/// will be formatted as a JSON.
Future<String> _fetchData(String endpoint) async {
	try {
		var response = await http.get(
			_BASE_URL + endpoint,
			headers: {
				"X-TBA-Auth-Key": "",
			}
		);
		// TODO Response type: 200 OK, *304 Not Modified*, 401 Not Authorized
		return response.body;
	} catch(e) {
		debugPrint("Failed to receive data from ${_BASE_URL + endpoint}");
		debugPrint(e.toString());
	}
	return null;
}

/// Attempts to parse the data received from TBA at the given [endpoint].
///
/// This will return the parsed data or null if there was an error during parsing.
Future<dynamic> fetchFromTBA(String endpoint) async {

	String body = await _fetchData(endpoint);

	if (body == null) return null;

	try {
		return jsonDecode(body);
	} catch (e) {
		debugPrint("Could not convert the data for endpoint: $endpoint");
		debugPrint(e.toString());
	}
	return null;
}