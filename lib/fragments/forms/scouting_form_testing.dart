import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/number_form_field.dart';
import '../scouting_drawer.dart';
import '../../util/database_manager.dart';
import '../../scouting_models/model_match_info.dart';

class FormTesting extends StatefulWidget {
  @override
  _FormTestingState createState() => _FormTestingState();
}

class _FormTestingState extends State<FormTesting> {
  static const _YEAR = 0;
  static const _DEFAULT_COMP_ID = "noCompId";

  final _formKey = GlobalKey<FormState>();
  ModelMatchInfo matchInfo;

  @override
  void initState() {
    super.initState();
    // Populate with default values
    matchInfo = ModelMatchInfo(
      matchType: "q",
      allianceColor: "r",
      teamPosition: 1,
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
                  Text("Please fill out all of the information below"),
                  Divider(height: 20.0, color: Colors.black),
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
                          value: "q", child: Text("Qualifications")),
                      DropdownMenuItem<String>(
                          value: "qf", child: Text("Quarterfinal")),
                      DropdownMenuItem<String>(
                          value: "sf", child: Text("Semifinal")),
                      DropdownMenuItem<String>(value: "f", child: Text("Final"))
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
                                  matchInfo.toMap(), _YEAR)
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
