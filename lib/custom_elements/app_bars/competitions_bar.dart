import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/cross_fade.dart';

class CompetitionsPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final Function _listBuilder;

  CompetitionsPageAppBar(this._listBuilder,
      {Key key, this.title: "Default Title"})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  _CompetitionsPageAppBarState createState() =>
      new _CompetitionsPageAppBarState(this.title);

  @override
  final Size preferredSize; // default is 56.0
}

class _CompetitionsPageAppBarState extends State<CompetitionsPageAppBar>
    with TickerProviderStateMixin {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  bool _toggleAppBar = true;
  Widget _searchIcon;
  Widget _appBarTitle;
  String title;

  _CompetitionsPageAppBarState(this.title) {
    _appBarTitle =
        MyCrossFade(title, _filter, 'Search...', _toggleAppBar, Icons.search)
            .build(context);
    _searchIcon = AnimatedCrossFade(
      duration: const Duration(milliseconds: 450),
      firstChild: new Icon(Icons.search),
      secondChild: new Icon(Icons.close),
      crossFadeState:
          _toggleAppBar ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._toggleAppBar == true) {
        _toggleAppBar = false;
      } else {
        _toggleAppBar = true;
        _filter.clear();
      }
      _searchIcon = AnimatedCrossFade(
        duration: const Duration(milliseconds: 450),
        firstChild: new Icon(Icons.search),
        secondChild: new Icon(Icons.close),
        crossFadeState: _toggleAppBar
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      );
      _appBarTitle =
          MyCrossFade(title, _filter, 'Search...', _toggleAppBar, Icons.search)
              .build(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _toggleAppBar = true;
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
                    Navigator.pushNamed(context, '/' + Constants.appHelpText);
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
            widget._listBuilder(_searchText, current: true),
            widget._listBuilder(_searchText, current: false)
          ],
        ),
      ),
    );
  }
}
