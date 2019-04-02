import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:howth_golf_live/app_theme.dart';
import 'package:howth_golf_live/constants.dart';

class ElementBuilder {
  String currentRoute;
  final ThemeData appTheme = AppThemeData().build();
  final Constants constants = Constants();

  ElementBuilder() {
    currentRoute = "/Competitions";
  }

  Drawer buildDrawer(BuildContext context) {
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
          _buildDrawerTile(context, constants.competitionsText),
          _buildDrawerTile(context, constants.resultsText),
          _buildDrawerTile(context, constants.clubLinksText),
          _buildDrawerTile(context, constants.appHelpText)
        ],
      ),
    );
  }

  ListTile _buildDrawerTile(BuildContext context, String text) {
    // TODO fixme
    String namedRoute = '/' + text;
    currentRoute = currentRoute == null ? '' : currentRoute;
    print(currentRoute + '||' + namedRoute);

    Icon icon = currentRoute == namedRoute
        ? Icon(Icons.radio_button_checked)
        : Icon(Icons.radio_button_unchecked);

    TextStyle style = currentRoute == namedRoute
        ? appTheme.textTheme.body2
        : appTheme.textTheme.body1;

    return ListTile(
      selected: true,
      title: Center(child: Text(text, style: style)),
      trailing: icon,
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, namedRoute);
        currentRoute = namedRoute;
      },
    );
  }

  AppBar buildTabAppBar(BuildContext context, String title) {
    return AppBar(
        centerTitle: true,
        title: Text(title, style: TextStyle(color: appTheme.primaryColorDark)),
        backgroundColor: appTheme.primaryColor,
        iconTheme: IconThemeData(color: appTheme.primaryColorDark),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Tap to search!',
            color: appTheme.primaryColorDark,
            onPressed: () {},
          )
        ],
        bottom: TabBar(
            labelColor: appTheme.primaryColorDark,
            indicator: BubbleTabIndicator(
              indicatorColor: appTheme.accentColor,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 25.0,
            ),
            tabs: <Widget>[
              _buildTab(context, constants.currentText),
              _buildTab(context, constants.archivedText),
              _buildTab(context, constants.favouritesText)
            ]));
  }

  Tab _buildTab(BuildContext context, String text) {
    return Tab(text: text);
  }

  AppBar buildAppBar(BuildContext context, String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: TextStyle(color: appTheme.primaryColorDark)),
      backgroundColor: appTheme.primaryColor,
      iconTheme: IconThemeData(color: appTheme.primaryColorDark),
    );
  }
}
