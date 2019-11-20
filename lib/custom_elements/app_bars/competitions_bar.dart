import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompetitionsPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final Function _listBuilder;

  CompetitionsPageAppBar(this._listBuilder, {this.title})
      : preferredSize = Size.fromHeight(56.0);

  @override
  _CompetitionsPageAppBarState createState() =>
      new _CompetitionsPageAppBarState();

  @override
  final Size preferredSize;
}

class _CompetitionsPageAppBarState extends State<CompetitionsPageAppBar>
    with StatefulAppBar {
  final TextEditingController _filter = TextEditingController();

  void _searchPressed() {
    setState(() {
      appBarTitle =
          actionPressed(appBarTitle, titleBar, inputBar, context, _filter);
    });
  }

  @override
  void initState() {
    super.initState();
    titleBar = buildTitleBar(widget.title);
    inputBar = buildInputBar(
        TextInputType.text, false, 'Enter search here...', _filter);
    title = widget.title;
    appBarTitle = titleBar;
    _filter.addListener(() {
      setState(() {
        inputText = _filter.text.isEmpty ? "" : _filter.text;
      });
    });
  }

  AnimatedCrossFade _getIconData() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 450),
      firstChild: new Icon(Icons.search),
      secondChild: new Icon(Icons.close),
      crossFadeState: appBarTitle != inputBar
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }

  BubbleTabIndicator _getTabIndicator() {
    return BubbleTabIndicator(
        indicatorColor: Constants.accentAppColor,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
        indicatorHeight: 25.0,
        insets: EdgeInsets.symmetric(vertical: 1.0, horizontal: 26.0));
  }

  void _toAppHelp() {
    final preferences = SharedPreferences.getInstance();

    preferences.then((SharedPreferences preferences) {
      Navigator.pushNamed(context, '/' + Constants.appHelpText,
          arguments: Privileges.buildFromPreferences(preferences));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                centerTitle: true,
                title: getTitle(appBarTitle),
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: Constants.primaryAppColor,
                iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
                leading: IconButton(
                    icon: Icon(Icons.help_outline),
                    tooltip: 'Tap for help!',
                    onPressed: _toAppHelp),
                actions: <Widget>[
                  IconButton(
                    icon: _getIconData(),
                    tooltip: 'Tap to search!',
                    onPressed: _searchPressed,
                  )
                ],
                bottom: TabBar(
                    labelColor: Constants.primaryAppColorDark,
                    indicator: _getTabIndicator(),
                    tabs: <Widget>[
                      Tab(text: Constants.currentText),
                      Tab(text: Constants.archivedText)
                    ])),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            widget._listBuilder(inputText, true),
            widget._listBuilder(inputText, false)
          ],
        ),
      ),
    );
  }
}
