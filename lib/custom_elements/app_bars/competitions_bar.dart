import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/cross_fade.dart';
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
  final Size preferredSize; // default is 56.0
}

class _CompetitionsPageAppBarState extends State<CompetitionsPageAppBar>
    with TickerProviderStateMixin {
  final TextEditingController _filter = TextEditingController();
  bool _toggleAppBar = true;
  String _searchText = "";
  String title;

  void _searchPressed() {
    setState(() {
      _toggleAppBar = !_toggleAppBar;

      if (_toggleAppBar) {
        _filter.clear();
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _toggleAppBar = true;
    title = widget.title;
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text.isEmpty ? "" : _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AnimatedCrossFade _searchIcon = AnimatedCrossFade(
      duration: const Duration(milliseconds: 450),
      firstChild: new Icon(Icons.search),
      secondChild: new Icon(Icons.close),
      crossFadeState:
          _toggleAppBar ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );

    Widget _appBarTitle = TitleCrossFade(_filter, _toggleAppBar,
        title: title,
        hintText: 'Search...',
        iconData: Icons.search,
        textInputType: TextInputType.text,
        password: false);

    return SafeArea(
      child: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                centerTitle: true,
                title: _appBarTitle,
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: Constants.primaryAppColor,
                iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
                leading: IconButton(
                  icon: Icon(Icons.help_outline),
                  tooltip: 'Tap for help!',
                  onPressed: () {
                    final preferences = SharedPreferences.getInstance();
                    preferences.then((SharedPreferences preferences) {
                      Navigator.pushNamed(context, '/' + Constants.appHelpText,
                          arguments:
                              Privileges.buildFromPreferences(preferences));
                    });
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: _searchIcon,
                    tooltip: 'Tap to search!',
                    onPressed: _searchPressed,
                  )
                ],
                bottom: TabBar(
                    labelColor: Constants.primaryAppColorDark,
                    indicator: BubbleTabIndicator(
                        indicatorColor: Constants.accentAppColor,
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        indicatorHeight: 25.0,
                        insets: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 30.0)),
                    tabs: <Widget>[
                      Tab(text: Constants.currentText),
                      Tab(text: Constants.archivedText)
                    ])),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            widget._listBuilder(_searchText, true),
            widget._listBuilder(_searchText, false)
          ],
        ),
      ),
    );
  }
}
