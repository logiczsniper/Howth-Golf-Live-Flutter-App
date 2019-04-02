import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:howth_golf_live/app_theme.dart';
import 'package:howth_golf_live/constants.dart';
import 'package:howth_golf_live/pages/tournaments_page.dart';
import 'package:howth_golf_live/pages/results_page.dart';
import 'package:howth_golf_live/pages/clublinks_page.dart';
import 'package:howth_golf_live/pages/apphelp_page.dart';

class ElementBuilder {
  final ThemeData appTheme = AppThemeData().build();
  final Constants constants = Constants();
  String currentPage = 'Competitions';

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
          _buildDrawerTile(
              context, constants.competitionsText, TournamentsPage()),
          _buildDrawerTile(context, constants.resultsText, ResultsPage()),
          _buildDrawerTile(context, constants.clubLinksText, ClubLinksPage()),
          _buildDrawerTile(context, constants.appHelpText, AppHelpPage())
        ],
      ),
    );
  }

  ListTile _buildDrawerTile(
      BuildContext context, String text, Widget destination) {
    Icon icon = currentPage == text
        ? Icon(Icons.radio_button_checked)
        : Icon(Icons.radio_button_unchecked);

    TextStyle style = currentPage == text
        ? appTheme.textTheme.body2
        : appTheme.textTheme.body1;

    return ListTile(
      title: Center(child: Text(text, style: style)),
      trailing: icon,
      onTap: () {
        currentPage = destination.toString();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => destination));
      },
    );
  }

  AppBar buildTabAppBar(BuildContext context, String title) {
    return AppBar(
        title: Center(child: Text(title)),
        backgroundColor: appTheme.primaryColorDark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Tap to search!',
            onPressed: () {},
          )
        ],
        bottom: TabBar(
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
      title: Center(child: Text(title)),
      backgroundColor: appTheme.primaryColorDark,
    );
  }
}
