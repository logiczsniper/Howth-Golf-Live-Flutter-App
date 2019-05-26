import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';

class AppDrawer extends StatelessWidget {
  ListTile buildDrawerTile(BuildContext context, String text, IconData icon) {
    String namedRoute = '/' + text;

    return ListTile(
      title: Center(
          child: Padding(
        padding: EdgeInsets.only(left: 24.0),
        child: Text(text,
            style:
                TextStyle(fontSize: 18, color: Constants.primaryAppColorDark)),
      )),
      trailing: Icon(icon, color: Constants.primaryAppColorDark),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, namedRoute);
      },
    );
  }

/* 
  static _launchUrl() async {
    if (await canLaunch("https://www.facebook.com/howthgolfclubdublin/")) {
      await launch("https://www.facebook.com/howthgolfclubdublin/");
    } else {
      throw 'Could not launch FacebookLink';
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 3 / 5,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(),
                curve: Curves.decelerate,
/*                   child: new Carousel(
                      images: [
                        'drawer_image_one.png',
                        'drawer_image_two.jpg',
                        'drawer_image_three.jpg',
                        'drawer_image_four.jpg',
                        'drawer_image_five.jpg',
                      ]
                          .map(
                              (path) => AssetImage('lib/static/images/' + path))
                          .toList(),
                      dotColor: Constants.primaryAppColor,
                      dotSize: 4.0,
                      dotSpacing: 10,
                      indicatorBgPadding: 15.0,
                      borderRadius: true,
                      radius: Radius.circular(12.0),
                      overlayShadow: false,
                      autoplay: false,
                      boxFit: BoxFit.fill) */
              ),
              buildDrawerTile(
                  context, Constants.competitionsText, Icons.golf_course),
/*               buildDrawerTile(context, Constants.managersText, Icons.people),
              buildDrawerTile(context, Constants.courseMapText, Icons.map), */
              buildDrawerTile(context, Constants.appHelpText, Icons.help),
              Padding(
                padding: EdgeInsets.only(bottom: 55),
              ),
/*               IconButton(
                  iconSize: 45,
                  color: Constants.accentAppColor,
                  icon: Icon(FontAwesomeIcons.facebookSquare),
                  tooltip: 'Howth Golf Club Facebook Page',
                  onPressed: () {
                    _launchUrl();
                  }), */
            ],
          ),
        ));
  }
}
