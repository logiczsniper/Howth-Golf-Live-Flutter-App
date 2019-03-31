import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants.dart';
import 'package:carousel_pro/carousel_pro.dart';

class PrimaryApp extends StatefulWidget {
  @override
  _PrimaryAppState createState() => new _PrimaryAppState();
}

class _PrimaryAppState extends State<PrimaryApp> {
  final Constants clubConstants = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Competitions")),
      drawer: Drawer(
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
                    dotColor: Color.fromARGB(255, 187, 187, 187),
                    dotSize: 4.0,
                    dotSpacing: 10,
                    indicatorBgPadding: 15.0,
                    borderRadius: true,
                    radius: Radius.circular(7.0),
                    overlayShadow: false,
                    overlayShadowSize: 0.0,
                    autoplayDuration: Duration(seconds: 6),
                    animationDuration: Duration(milliseconds: 350),
                    boxFit: BoxFit.fill)),
            ListTile(
              title: Center(
                  child: Text('Competition',
                      style: Theme.of(context).textTheme.body2)),
              // TODO have the icon on the current page be checked, the rest unchecked.
              // in addition, the selected page will have body2 theme, unselected body1.
              trailing: Icon(Icons.radio_button_checked),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Center(
                  child: Text('Results',
                      style: Theme.of(context).textTheme.body1)),
              trailing: Icon(Icons.radio_button_unchecked),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Center(
                  child: Text('Club Links',
                      style: Theme.of(context).textTheme.body1)),
              trailing: Icon(Icons.radio_button_unchecked),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Center(
                  child: Text('App Help',
                      style: Theme.of(context).textTheme.body1)),
              trailing: Icon(Icons.radio_button_unchecked),
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
