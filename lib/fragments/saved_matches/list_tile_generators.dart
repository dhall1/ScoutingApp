import 'dart:convert';

String generateTestSubtitle(Map<String, dynamic> matchData) {
	return jsonEncode(matchData);
}

String generate2019Subtitle(Map<String, dynamic> matchData) {
	return '''
Competition: ${matchData["competitionKey"]}
Alliance Partners: ${matchData["partner1"]}, ${matchData["partner2"]}
Started ${matchData["sandstormPlatformSuccess"] == 1 ? "" : "un"}successfully on HAB Platform ${matchData["sandstormStartingLevel"]}
Placed ${matchData["hatchesOnRocket"]} hatches on and ${matchData["cargoInRocket"]} cargo in the rocket
Placed ${matchData["hatchesOnCargoShip"]} hatches on and ${matchData["cargoInCargoShip"]} cargo in the rocket
Ended on HAB platform ${matchData["endgamePlatformLevel"]}''';
}