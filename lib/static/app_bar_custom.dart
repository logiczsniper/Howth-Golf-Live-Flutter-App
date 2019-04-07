import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_fading_element.dart';
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

  List currentEntries = new List();
  List filteredCurrentEntries = new List();

  List archivedEntries = new List();
  List filteredArchivedEntries = new List();

  List favouriteEntries = new List();
  List filteredFavouriteEntries = new List();

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle;
  bool _toggle;
  Function _importEntries;
  String title;

  _ComplexAppBarState(this.title, this._importEntries) {
    _appBarTitle = Text(title,
        style: TextStyle(color: Color.fromARGB(255, 187, 187, 187)));

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
    OutlineInputBorder outlineInputBorder = new OutlineInputBorder(
      borderSide: BorderSide(color: appTheme.accentColor, width: 1.8),
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
    );

    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(
          Icons.close,
        );
        _toggle = false;
      } else {
        this._searchIcon = new Icon(
          Icons.search,
        );
        _toggle = true;
        filteredCurrentEntries = currentEntries;
        filteredArchivedEntries = archivedEntries;
        filteredFavouriteEntries = favouriteEntries;
        _filter.clear();
      }
      this._appBarTitle = AnimatedCrossFade(
        firstCurve: Curves.easeInCubic,
        secondCurve: Curves.easeInQuint,
        crossFadeState:
            _toggle ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 1020),
        firstChild: Text(title,
            style: TextStyle(
              color: appTheme.primaryColorDark,
            )),
        secondChild: new TextField(
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          controller: _filter,
          style: TextStyle(color: appTheme.primaryColorDark),
          decoration: new InputDecoration(
              contentPadding: EdgeInsets.all(1.5),
              enabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              prefixIcon:
                  new Icon(Icons.search, color: appTheme.primaryColorDark),
              hintText: 'Search...',
              hintStyle: appTheme.textTheme.subhead),
        ),
      );
    });
  }

  Tab _buildTab(BuildContext context, String text) {
    return Tab(text: text);
  }

  @override
  void initState() {
    this._getEntries();
    super.initState();
    this._toggle = false;
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
