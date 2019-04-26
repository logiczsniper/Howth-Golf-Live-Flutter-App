import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_resources.dart';
import 'package:howth_golf_live/custom_elements/app_custom_cross_fade.dart';

class ComplexAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function _listBuilder;

  ComplexAppBar(this._listBuilder, {Key key, this.title: "Default Title"})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  _ComplexAppBarState createState() => new _ComplexAppBarState(this.title);

  @override
  final Size preferredSize; // default is 56.0
}

class _ComplexAppBarState extends State<ComplexAppBar> with AppResources {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  bool _toggleAppBar;
  Widget _searchIcon;
  Widget _appBarTitle;
  String title;

  _ComplexAppBarState(this.title) {
    _appBarTitle = MyCrossFade(title, _filter).build(context);
    _searchIcon = Icon(Icons.search);

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
      _appBarTitle = MyCrossFade(title, _filter, _toggleAppBar).build(context);
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
                backgroundColor: appTheme.primaryColor,
                iconTheme: IconThemeData(color: appTheme.primaryColorDark),
                actions: <Widget>[
                  IconButton(
                    icon: _searchIcon,
                    tooltip: 'Tap to search!',
                    onPressed: _searchPressed,
                    color: appTheme.primaryColorDark,
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
                      Tab(text: constants.currentText),
                      Tab(text: constants.archivedText),
                      Tab(text: constants.favouritesText),
                    ])),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            widget._listBuilder(_searchText, 1),
            widget._listBuilder(_searchText, 0),
            widget._listBuilder(_searchText, 1)
          ],
        ),
      ),
    );
  }
}

class StandardAppBar extends StatelessWidget
    with AppResources
    implements PreferredSizeWidget {
  final String title;

  StandardAppBar(this.title, {Key key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize; //

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: TextStyle(color: appTheme.primaryColorDark)),
      backgroundColor: appTheme.primaryColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: appTheme.primaryColorDark),
    );
  }
}
