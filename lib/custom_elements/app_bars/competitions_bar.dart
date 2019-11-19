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
      appBarTitle = actionPressed(
          appBarTitle, primaryTitle, secondaryTitle, context, _filter);
    });
  }

  @override
  void initState() {
    super.initState();
    // TODO: renaming app bars
    primaryTitle = buildPrimaryBar(widget.title);
    secondaryTitle = buildSecondaryBar(
        TextInputType.text, false, 'Enter search here...', _filter);
    title = widget.title;
    appBarTitle = primaryTitle;
    _filter.addListener(() {
      setState(() {
        inputText = _filter.text.isEmpty ? "" : _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: extract to method
    AnimatedCrossFade _searchIcon = AnimatedCrossFade(
      duration: const Duration(milliseconds: 450),
      firstChild: new Icon(Icons.search),
      secondChild: new Icon(Icons.close),
      crossFadeState: appBarTitle != secondaryTitle
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );

    return SafeArea(
      child: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            // TODO: extract to custom widget class
            SliverAppBar(
                centerTitle: true,
                // TODO: both competitions_bar and code_field_bar have this animated switcher. DO somehting
                title: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500), child: appBarTitle),
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: Constants.primaryAppColor,
                iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
                leading: IconButton(
                  icon: Icon(Icons.help_outline),
                  tooltip: 'Tap for help!',
                  onPressed: () {
                    // TODO: extract method
                    final preferences = SharedPreferences.getInstance();
                    preferences.then((SharedPreferences preferences) {
                      Navigator.pushNamed(context, '/' + Constants.appHelpText,
                          arguments:
                              Privileges.buildFromPreferences(preferences));
                    });
                  },
                ),
                actions: <Widget>[
                  // TODO: include in above icon extraction
                  IconButton(
                    icon: _searchIcon,
                    tooltip: 'Tap to search!',
                    onPressed: _searchPressed,
                  )
                ],
                bottom: TabBar(
                    labelColor: Constants.primaryAppColorDark,
                    // TODO: extract bubbletabindicator
                    indicator: BubbleTabIndicator(
                        indicatorColor: Constants.accentAppColor,
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        indicatorHeight: 25.0,
                        insets: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 26.0)),
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
