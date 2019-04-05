import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_drawer.dart';
import 'package:howth_golf_live/static/app_resources.dart';

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
  List entries = new List();
  List filteredEntries = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle;
  Function _importEntries;
  String title;

  _ComplexAppBarState(this.title, this._importEntries) {
    _appBarTitle = Text(title,
        style: TextStyle(color: Color.fromARGB(255, 187, 187, 187)));

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredEntries = entries;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _getEntries() {
    List tempList = this._importEntries();

    setState(() {
      entries = tempList;
      filteredEntries = entries;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          style: TextStyle(color: Color.fromARGB(255, 187, 187, 187)),
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(title,
            style: TextStyle(color: Color.fromARGB(255, 187, 187, 187)));
        filteredEntries = entries;
        _filter.clear();
      }
    });
  }

  Tab _buildTab(BuildContext context, String text) {
    return Tab(text: text);
  }

  @override
  void initState() {
    this._getEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: _appBarTitle,
            backgroundColor: appTheme.primaryColor,
            iconTheme: IconThemeData(color: appTheme.primaryColorDark),
            actions: <Widget>[
              IconButton(
                icon: _searchIcon,
                tooltip: 'Tap to search!',
                color: appTheme.primaryColorDark,
                onPressed: _searchPressed,
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
        drawer: AppDrawer(),
        body: TabBarView(
          children: <Widget>[
            widget._listBuilder(_searchText, filteredEntries, entries),
            widget._listBuilder(_searchText, filteredEntries, entries),
            widget._listBuilder(_searchText, filteredEntries, entries)
          ],
        ));
  }
}

class StandardAppBar extends StatelessWidget with AppResources {
  final String title;

  StandardAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: TextStyle(color: appTheme.primaryColorDark)),
      backgroundColor: appTheme.primaryColor,
      iconTheme: IconThemeData(color: appTheme.primaryColorDark),
    );
  }
}
