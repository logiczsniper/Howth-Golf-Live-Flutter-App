import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class AppDrawer extends StatelessWidget with AppResources {
  ListTile buildDrawerTile(BuildContext context, String text, IconData icon) {
    String namedRoute = '/' + text;

    return ListTile(
      title: Text(text, style: appTheme.textTheme.body2),
      trailing: Icon(icon, color: appTheme.primaryColorDark),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, namedRoute);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: new Carousel(
                  images: [
                    'images/drawer_image_one.png',
                    'images/drawer_image_two.jpg',
                    'images/drawer_image_three.jpg',
                    'images/drawer_image_four.jpg',
                    'images/drawer_image_five.jpg',
                  ].map((path) => AssetImage(path)).toList(),
                  dotColor: appTheme.primaryColor,
                  dotSize: 4.0,
                  dotSpacing: 10,
                  indicatorBgPadding: 15.0,
                  borderRadius: true,
                  radius: Radius.circular(20.0),
                  overlayShadow: false,
                  autoplay: false,
                  boxFit: BoxFit.fill)),
          buildDrawerTile(
              context, constants.competitionsText, Icons.golf_course),
          buildDrawerTile(context, constants.resultsText, Icons.stars),
          buildDrawerTile(context, constants.clubLinksText, Icons.link),
          buildDrawerTile(context, constants.appHelpText, Icons.help)
        ],
      ),
    );
  }
}
