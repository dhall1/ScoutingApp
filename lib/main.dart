import 'package:flutter/material.dart';

import 'fragments/competition_selection.dart';
import 'fragments/forms/scouting_form_testing.dart';
import 'fragments/forms/scouting_form_2019.dart';
import 'fragments/saved_matches/saved_matches.dart';
import 'fragments/scouter_info.dart';
import 'fragments/settings_menu.dart';

/// Launch the app
void main() => runApp(ScoutingApp());

/// The main entry point of the app
class ScoutingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scouting",
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: ScouterInfoMenu(),
      routes: {
        // Saved data routes
        "/saved_matches/0": (BuildContext ctx) => SavedMatches(0),
        "/saved_matches/2019": (BuildContext ctx) => SavedMatches(2019),

        // Add data routes
        "/add_data/0": (BuildContext ctx) => FormTesting(),
        "/add_data/2019": (BuildContext ctx) => ScoutingForm2019(),

        // Scouter Information routes
        "/scouter_info": (BuildContext ctx) => ScouterInfoMenu(),
        "/scouter_info/comp_selection": (BuildContext ctx) =>
            CompetitionSelection(2019),

        // Settings Menu routes
        "/settings_menu": (BuildContext ctx) => SettingsMenu(),
      },
    );
  }
}
