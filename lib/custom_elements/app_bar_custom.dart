import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_resources.dart';
import 'package:howth_golf_live/custom_elements/app_custom_cross_fade.dart';

class ComplexAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function _importEntries;
  final Function _listBuilder;

  ComplexAppBar(this._importEntries, this._listBuilder,
      {Key key, this.title: "Default Title"})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  _ComplexAppBarState createState() =>
      new _ComplexAppBarState(this.title, this._importEntries);

  @override
  final Size preferredSize; // default is 56.0
}

class _ComplexAppBarState extends State<ComplexAppBar> with AppResources {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";

  List currentEntries = new List();
  List filteredCurrentEntries = new List();

  List archivedEntries = new List();
  List filteredArchivedEntries = new List();

  List favouriteEntries = new List();
  List filteredFavouriteEntries = new List();

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle;
  bool _toggleTitle = true;
  Function _importEntries;
  String title;

  _ComplexAppBarState(this.title, this._importEntries) {
    _appBarTitle = MyCrossFade(title).build(context);

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredCurrentEntries = currentEntries;
          filteredArchivedEntries = archivedEntries;
          filteredFavouriteEntries = favouriteEntries;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _getEntries() {
    Map tempList = this._importEntries();

    setState(() {
      currentEntries = tempList[constants.currentText];
      filteredCurrentEntries = currentEntries;

      archivedEntries = tempList[constants.archivedText];
      filteredArchivedEntries = archivedEntries;

      favouriteEntries = tempList[constants.favouritesText];
      filteredFavouriteEntries = favouriteEntries;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(
          Icons.close,
        );
        _toggleTitle = false;
      } else {
        this._searchIcon = new Icon(
          Icons.search,
        );
        _toggleTitle = true;
        filteredCurrentEntries = currentEntries;
        filteredArchivedEntries = archivedEntries;
        filteredFavouriteEntries = favouriteEntries;
        _filter.clear();
      }
      this._appBarTitle = MyCrossFade(title, _toggleTitle).build(context);
    });
  }

  Tab _buildTab(BuildContext context, String text) {
    return Tab(text: text);
  }

  @override
  void initState() {
    this._getEntries();
    super.initState();
    this._toggleTitle = false;
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
                      _buildTab(context, constants.currentText),
                      _buildTab(context, constants.archivedText),
                      _buildTab(context, constants.favouritesText)
                    ])),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            widget._listBuilder(
                _searchText, filteredCurrentEntries, currentEntries),
            widget._listBuilder(
                _searchText, filteredArchivedEntries, archivedEntries),
            widget._listBuilder(
                _searchText, filteredFavouriteEntries, favouriteEntries)
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
