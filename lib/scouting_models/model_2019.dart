/// Holds game-specific information about a team's performance in the 2019
/// Destination: Deep Space game.
class Model2019 {

	/// Sandstorm HAB Platform starting level
	int sandstormStartingLevel;

	/// 1 if the bot successfully left the HAB Platform during the Sandstorm
	bool sandstormPlatformSuccess;

	/// Number of hatches the robot placed on the rocket
	int hatchesOnRocket;

	/// Number of cargo the robot placed in the rocket
	int cargoInRocket;

	/// Number of hatches the robot placed on the cargo ship
	int hatchesOnCargoShip;

	/// Number of cargo the robot placed in the cargo ship
	int cargoInCargoShip;

	/// HAB Platform the robot ends the match on
	int endgamePlatformLevel;

	/// 1 if the alliance got the docking RP, 0 if not
	bool dockingRP;

	/// 1 if the alliance got the docking RP, 0 if not
	bool rocketRP;

	/// "w" if the alliance won, "t" if the alliance tied, or "l" if the alliance lost
	String winStatus;

	/// Creates a 2019 Data Model
	Model2019({
		this.sandstormStartingLevel,
		this.sandstormPlatformSuccess,
		this.hatchesOnRocket,
		this.cargoInRocket,
		this.hatchesOnCargoShip,
		this.cargoInCargoShip,
		this.endgamePlatformLevel,
		this.dockingRP,
		this.rocketRP,
		this.winStatus
	});

	/// Convert to a 2019 Data model from a map or JSON.
	Model2019.fromMap(Map<String, dynamic> map) :
			this.sandstormStartingLevel = map["sandstormStartingLevel"],
			this.sandstormPlatformSuccess = map['sandstormPlatformSuccess'] == 0 ? false : true,
			this.hatchesOnRocket = map["hatchesOnRocket"],
			this.cargoInRocket = map["cargoInRocket"],
			this.hatchesOnCargoShip = map["hatchesOnCargoShip"],
			this.cargoInCargoShip = map["cargoInCargoShip"],
			this.endgamePlatformLevel = map["endgamePlatformLevel"],
			this.dockingRP = map["dockingRP"] == 0 ? false : true,
			this.rocketRP = map["rocketRP"] == 0 ? false : true,
			this.winStatus = map["winStatus"];

	/// Convert a 2019 Data Model to a map or JSON.
	Map<String, dynamic> toMap() {
		return {
			"sandstormStartingLevel": sandstormStartingLevel,
			"sandstormPlatformSuccess": sandstormPlatformSuccess ? 1 : 0,
			"hatchesOnRocket": hatchesOnRocket,
			"cargoInRocket": cargoInRocket,
			"hatchesOnCargoShip": hatchesOnCargoShip,
			"cargoInCargoShip": cargoInCargoShip,
			"endgamePlatformLevel": endgamePlatformLevel,
			"dockingRP": dockingRP ? 1 : 0,
			"rocketRP": rocketRP ? 1 : 0,
			"winStatus": winStatus
		};
	}

}