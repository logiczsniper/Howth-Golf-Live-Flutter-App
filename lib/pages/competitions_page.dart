import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_resources.dart';
import 'package:dio/dio.dart';

class CompetitionsPage extends StatefulWidget with AppResources {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.competitionsText;
  }

  @override
  _CompetitionsPageState createState() => new _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> with AppResources {
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  List competitions = new List(); // names we get from API
  List filteredCompetitions = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = Text("Competitions",
      style: TextStyle(color: Color.fromARGB(255, 187, 187, 187)));

  /// Use once the backend is complete to request a list of tournaments
/*     void _getCompetitions() async {
      final response = await dio.get('MY SERVERLESS ENDPOINT');
      List tempList = new List();
      for (int i = 0; i < response.data['results'].length; i++) {
        tempList.add(response.data['results'][i]);
      }
      setState(() {
        competitions = tempList;
        filteredCompetitions = competitions;
      });
    } */

  _CompetitionsPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredCompetitions = competitions;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getCompetitions();
    super.initState();
  }

  void _getCompetitions() {
    List tempList = ['bobs', 'your', 'uncle'];

    setState(() {
      competitions = tempList;
      filteredCompetitions = competitions;
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
        this._appBarTitle = new Text(constants.competitionsText,
            style: TextStyle(color: Color.fromARGB(255, 187, 187, 187)));
        filteredCompetitions = competitions;
        _filter.clear();
      }
    });
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredCompetitions.length; i++) {
        if (filteredCompetitions[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredCompetitions[i]);
        }
      }
      filteredCompetitions = tempList;
    }
    return ListView.builder(
      itemCount: competitions == null ? 0 : filteredCompetitions.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredCompetitions[index]),
          onTap: () => print(filteredCompetitions[index]),
        );
      },
    );
  }

  Tab _buildTab(BuildContext context, String text) {
    return Tab(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
                drawer: elementBuilder.buildDrawer(context),
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
                body: TabBarView(
                  children: <Widget>[_buildList(), _buildList(), _buildList()],
                ))));
  }
}
