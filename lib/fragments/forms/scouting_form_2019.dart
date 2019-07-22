import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/counter_form_field.dart';
import 'components/number_form_field.dart';
import '../scouting_drawer.dart';
import '../../util/database_manager.dart';
import '../../scouting_models/model_match_info.dart';
import '../../scouting_models/model_2019.dart';

class ScoutingForm2019 extends StatefulWidget {
  @override
  _ScoutingForm2019State createState() => _ScoutingForm2019State();
}

class _ScoutingForm2019State extends State<ScoutingForm2019> {
  static const _YEAR = 2019;
  static const _DEFAULT_COMP_ID = "noCompId";

  final _formKey = GlobalKey<FormState>();
  ModelMatchInfo matchInfo;
  Model2019 data2019;

  @override
  void initState() {
    super.initState();
    // Populate with default values
    matchInfo = ModelMatchInfo(
      matchType: "q",
      allianceColor: "r",
      teamPosition: 1,
    );
    data2019 = Model2019(
      sandstormStartingLevel: 1,
      sandstormPlatformSuccess: false,
      hatchesOnRocket: 0,
      cargoInRocket: 0,
      hatchesOnCargoShip: 0,
      cargoInCargoShip: 0,
      endgamePlatformLevel: 1,
      dockingRP: false,
      rocketRP: false,
      winStatus: "l",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Data"),
      ),
      drawer: ScoutingAppDrawer(),
      // Wrapped in a builder to provide a BuildContext that is a child of
      // a Scaffold widget to allow creating snackbars in the Scaffold's context
      body: Builder(
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: matchInfo.matchType,
                    onChanged: (String value) {
                      setState(() {
                        matchInfo.matchType = value;
                      });
                    },
                    decoration: InputDecoration(labelText: "Match Type"),
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: "q",
                        child: Text("Qualifications"),
                      ),
                      DropdownMenuItem<String>(
                        value: "qf",
                        child: Text("Quarterfinal"),
                      ),
                      DropdownMenuItem<String>(
                        value: "sf",
                        child: Text("Semifinal"),
                      ),
                      DropdownMenuItem<String>(
                        value: "f",
                        child: Text("Final"),
                      )
                    ],
                  ),
                  NumberFormField(
                    decoration: InputDecoration(
                        labelText: "Match Number",
                        hintText: "Enter the match number"),
                    onSaved: (int value) => matchInfo.matchNumber = value,
                  ),
                  NumberFormField(
                    decoration: InputDecoration(
                        labelText: "Team Number",
                        hintText: "Enter the scouted team's number"),
                    onSaved: (int value) => matchInfo.teamNumber = value,
                  ),
                  DropdownButtonFormField<String>(
                    value: matchInfo.allianceColor,
                    onChanged: (String value) {
                      setState(() {
                        matchInfo.allianceColor = value;
                      });
                    },
                    decoration: InputDecoration(labelText: "Alliance Color"),
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: "r",
                        child: Text("Red"),
                      ),
                      DropdownMenuItem<String>(
                        value: "b",
                        child: Text("Blue"),
                      )
                    ],
                  ),
                  DropdownButtonFormField<int>(
                    value: matchInfo.teamPosition,
                    onChanged: (int value) {
                      setState(() {
                        matchInfo.teamPosition = value;
                      });
                    },
                    decoration: InputDecoration(labelText: "Team Position"),
                    items: [1, 2, 3].map((int value) {
                      return DropdownMenuItem<int>(
                          value: value, child: Text("$value"));
                    }).toList(),
                  ),
                  NumberFormField(
                    decoration: InputDecoration(
                        labelText: "Alliance Member 1",
                        hintText: 'Enter a team number'),
                    onSaved: (int value) => matchInfo.partner1 = value,
                  ),
                  NumberFormField(
                    decoration: InputDecoration(
                        labelText: "Alliance Member 2",
                        hintText: 'Enter a team number'),
                    onSaved: (int value) => matchInfo.partner2 = value,
                  ),
                  DropdownButtonFormField<int>(
                    value: data2019.sandstormStartingLevel,
                    onChanged: (int value) {
                      setState(() {
                        data2019.sandstormStartingLevel = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: "Sandstorm Starting Platform"),
                    items: [1, 2].map((int value) {
                      return DropdownMenuItem<int>(
                          value: value, child: Text("$value"));
                    }).toList(),
                  ),
                  CheckboxListTile(
                      title: Text("Successfully left HAB Platform"),
                      value: data2019.sandstormPlatformSuccess,
                      onChanged: (bool value) {
                        setState(() {
                          data2019.sandstormPlatformSuccess = value;
                        });
                      }),
                  CounterFormField(
                    title: "Hatches on Rocket",
                    onSaved: (int value) {
                      setState(() {
                        data2019.hatchesOnRocket = value;
                      });
                    },
                    validator: (int value) {
                      if (value < 0) {
                        return "This number must be 0 or more";
                      }
                    },
                  ),
                  CounterFormField(
                    title: "Cargo in Rocket",
                    onSaved: (int value) {
                      setState(() {
                        data2019.cargoInRocket = value;
                      });
                    },
                    validator: (int value) {
                      if (value < 0) {
                        return "This number must be 0 or more";
                      }
                    },
                  ),
                  CounterFormField(
                    title: "Hatches on Cargo Ship",
                    onSaved: (int value) {
                      setState(() {
                        data2019.hatchesOnCargoShip = value;
                      });
                    },
                    validator: (int value) {
                      if (value < 0) {
                        return "This number must be 0 or more";
                      }
                    },
                  ),
                  CounterFormField(
                    title: "Cargo in Cargo Ship",
                    onSaved: (int value) {
                      setState(() {
                        data2019.cargoInCargoShip = value;
                      });
                    },
                    validator: (int value) {
                      if (value < 0) {
                        return "This number must be 0 or more";
                      }
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: data2019.endgamePlatformLevel,
                    onChanged: (int value) {
                      setState(() {
                        data2019.endgamePlatformLevel = value;
                      });
                    },
                    decoration:
                        InputDecoration(labelText: "Endgame Platform Level"),
                    items: [1, 2, 3].map((int value) {
                      return DropdownMenuItem<int>(
                          value: value, child: Text("$value"));
                    }).toList(),
                  ),
                  CheckboxListTile(
                      title: Text("Docking Rank Point"),
                      value: data2019.dockingRP,
                      onChanged: (bool value) {
                        setState(() {
                          data2019.dockingRP = value;
                        });
                      }),
                  CheckboxListTile(
                      title: Text("Rocket Rank Point"),
                      value: data2019.rocketRP,
                      onChanged: (bool value) {
                        setState(() {
                          data2019.rocketRP = value;
                        });
                      }),
                  DropdownButtonFormField<String>(
                      value: data2019.winStatus,
                      onChanged: (String value) {
                        setState(() {
                          data2019.winStatus = value;
                        });
                      },
                      decoration: InputDecoration(labelText: "Won Match?"),
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: "w",
                          child: Text("Won"),
                        ),
                        DropdownMenuItem<String>(
                          value: "t",
                          child: Text("Tied"),
                        ),
                        DropdownMenuItem<String>(
                          value: "l",
                          child: Text("Lost"),
                        )
                      ]),
                  RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Scaffold.of(ctx).showSnackBar(
                            SnackBar(content: Text("Saving Data")));
                        matchInfo.timestamp =
                            (DateTime.now()).millisecondsSinceEpoch;
                        SharedPreferences.getInstance().then((preferences) {
                          matchInfo.scoutId =
                              preferences.getString("name") ?? "No name given";
                          matchInfo.competitionKey =
                              preferences.getString("currentCompKey") ??
                                  _DEFAULT_COMP_ID;
                          DatabaseManager.saveMatchData(
                                  matchInfo.toMap()..addAll(data2019.toMap()),
                                  _YEAR)
                              .then((id) {
                            Navigator.pushNamed(
                                context, "/saved_matches/$_YEAR");
                          });
                        });
                      } else {
                        Scaffold.of(ctx).showSnackBar(SnackBar(
                            content: Text("Some fields are not filled out!")));
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
