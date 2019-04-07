import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_bar_custom.dart';
import 'package:howth_golf_live/static/app_drawer.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class ResultsPage extends StatefulWidget with AppResources {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.resultsText;
  }

  @override
  _ResultsPageState createState() => new _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> with AppResources {
  /// Use once the backend is complete to request a list of results
/*     
import 'package:WEB SCRAPING PACKAGE';

void _getResults() async {
      
      BUILD SMART WEB SCRAPER HERE

    } */
  Map _getResults() {
    List tempListCurrent = ['current', 'your', 'resultssss'];
    List tempListArchived = ['archived', 'your', 'resultssss'];
    List tempListFavourites = ['favourites', 'your', 'resultssss'];

    Map<String, List> output = {
      constants.currentText: tempListCurrent,
      constants.archivedText: tempListArchived,
      constants.favouritesText: tempListFavourites
    };

    return output;
  }

  Widget _buildResultsList(
      String _searchText, List filteredResults, List results) {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredResults.length; i++) {
        if (filteredResults[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredResults[i]);
        }
      }
      filteredResults = tempList;
    }
    return ListView.builder(
      itemCount: results == null ? 0 : filteredResults.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 1.8,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 248, 248),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 15.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.5, color: appTheme.accentColor))),
                    child: Text("00 - 00", style: appTheme.textTheme.caption),
                  ),
                  title: Text(
                    filteredResults[index].toString(),
                    style: appTheme.textTheme.body2,
                  ),
                  subtitle: Text("00/00/0000 - 11/11/1111",
                      style: appTheme.textTheme.subhead),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: appTheme.primaryColorDark))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: DefaultTabController(
          length: 3,
          child: ComplexAppBar(_getResults, _buildResultsList,
              title: constants.resultsText)),
      backgroundColor: appTheme.primaryColor,
    );
  }
}
