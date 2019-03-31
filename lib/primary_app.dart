import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants.dart';

class PrimaryApp extends StatelessWidget {
  final Constants clubConstants = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Competitions")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(clubConstants.clubName,
                  style: Theme.of(context).textTheme.caption),
              accountEmail: Text(clubConstants.clubMobile,
                  style: Theme.of(context).textTheme.caption),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/drawer_image.png'),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              title: Text('Competitions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Results'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Club Links'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('App Help'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
