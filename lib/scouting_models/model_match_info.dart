/// Holds general match information, such as scouter, competition and alliance
/// info.
///
/// This information should not change much year to year.
class ModelMatchInfo {

	/// The id or name of the scout.
	String scoutId;

	/// The time when data was submitted.
	int timestamp;

	/// The competition key (as taken from thebluealliance).
	String competitionKey;

	/// The type of match.
	///
	/// Types:
	/// * Qualification ('q')
	/// * Quarterfinals ('qf')
	/// * Semifinals ('sf')
	/// * Finals ('f')
	String matchType;

	/// The match number.
	int matchNumber;

	/// The team number being scouted.
	int teamNumber;

	/// The team's alliance color ('r' or 'b').
	String allianceColor;

	/// The team's driver station position.
	int teamPosition;

	/// The team's first partner.
	int partner1;

	/// The team's second partner.
	int partner2;

	/// Creates a Testing Model.
	ModelMatchInfo({
		this.scoutId,
		this.timestamp,
		this.competitionKey,
		this.matchType,
		this.matchNumber,
		this.teamNumber,
		this.allianceColor,
		this.teamPosition,
		this.partner1,
		this.partner2
	});

	/// Convert to a Match Info Model from a map or JSON.
	ModelMatchInfo.fromMap(Map<String, dynamic> map) :
			this.scoutId = map["scoutId"],
			this.timestamp = map["timestamp"],
			this.competitionKey = map["competitionKey"],
			this.matchType = map["matchType"],
			this.matchNumber = map["matchNumber"],
			this.teamNumber = map["teamNumber"],
			this.allianceColor = map["allianceColor"],
			this.teamPosition = map["teamPosition"],
			this.partner1 = map["partner1"],
			this.partner2 = map["partner2"];

	/// Convert a Match Info Model to a map or JSON.
	Map<String, dynamic> toMap() {
		return {
			"scoutId": this.scoutId,
			"timestamp": this.timestamp,
			"competitionKey": this.competitionKey,
			"matchType": this.matchType,
			"matchNumber": this.matchNumber,
			"teamNumber": this.teamNumber,
			"allianceColor": this.allianceColor,
			"teamPosition": this.teamPosition,
			"partner1": this.partner1,
			"partner2": this.partner2
		};
	}
}