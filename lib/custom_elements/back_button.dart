import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBackButton extends StatelessWidget {
  final String destination;
  MyBackButton(this.destination);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const BackButtonIcon(),
        onPressed: () {
          final preferences = SharedPreferences.getInstance();
          preferences.then(
            (SharedPreferences preferences) {
              Navigator.pushNamed(context, '/' + destination,
                  arguments: Privileges.buildFromPreferences(preferences));
            },
          );
        });
  }
}
