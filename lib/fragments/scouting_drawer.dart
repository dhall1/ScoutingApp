import 'package:flutter/material.dart';

/// Drawer for all widgets in the app.
///
/// Includes the Saved Matches page, Add Data page, and Settings page, along with
/// a drawer header. Login information may later be presented in the drawer header
class ScoutingAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "FRC Scouting App",
                style: Theme.of(context).textTheme.headline,
              ),
            ],
          )),
          ListTile(
            leading: Icon(Icons.view_list),
            title: Text("Saved Matches - Test"),
            subtitle: Text("View locally saved matches for 0"),
            onTap: () => Navigator.pushNamed(context, "/saved_matches/0"),
          ),
          ListTile(
            leading: Icon(Icons.view_list),
            title: Text("Saved Matches - Destination: Deep Space"),
            subtitle: Text("View locally saved matches for 2019"),
            onTap: () => Navigator.pushNamed(context, "/saved_matches/2019"),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Add Data - Test"),
            subtitle: Text("Year: 0"),
            onTap: () => Navigator.pushNamed(context, "/add_data/0"),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Add Data - Destination: Deep Space"),
            subtitle: Text("Year: 2019"),
            onTap: () => Navigator.pushNamed(context, "/add_data/2019"),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Scouter Info"),
            onTap: () => Navigator.pushNamed(context, "/scouter_info"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () => Navigator.pushNamed(context, "/settings_menu"),
          )
        ],
      ),
    );
  }
}
