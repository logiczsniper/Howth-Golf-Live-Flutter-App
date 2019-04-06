import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_bar_custom.dart';
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
        return new ListTile(
          title: Text(filteredResults[index]),
          onTap: () => print(filteredResults[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 3,
            child: ComplexAppBar(_getResults, _buildResultsList,
                title: constants.resultsText)));
  }
}
