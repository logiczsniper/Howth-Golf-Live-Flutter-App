import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:howth_golf_live/app_theme.dart';

class ElementBuilder {
  final ThemeData appTheme = AppThemeData().build();

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
          _buildListTile(
              context,
              'Competitions',
              Theme.of(context).textTheme.body2,
              Icon(Icons.radio_button_checked),
              null),
          _buildListTile(context, 'Results', Theme.of(context).textTheme.body1,
              Icon(Icons.radio_button_unchecked), null),
          _buildListTile(
              context,
              'Club Links',
              Theme.of(context).textTheme.body1,
              Icon(Icons.radio_button_unchecked),
              null),
          _buildListTile(context, 'App Help', Theme.of(context).textTheme.body1,
              Icon(Icons.radio_button_unchecked), null)
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String text, TextStyle style,
      Icon icon, Widget destination) {
    return ListTile(
      title: Center(child: Text(text, style: style)),
      // TODO have the icon on the current page be checked, the rest unchecked.
      // in addition, the selected page will have body2 theme, unselected body1.
      trailing: icon,
      onTap: () {
        Navigator.pop(context);
        //Navigator.push(
        //    context, MaterialPageRoute(builder: (context) => destination));
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Center(child: Text('Competitions')),
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
              _buildTab(context, 'Current'),
              _buildTab(context, 'Archived'),
              _buildTab(context, 'Favourites')
            ]));
  }

  Tab _buildTab(BuildContext context, String text) {
    return Tab(text: text);
  }
}
