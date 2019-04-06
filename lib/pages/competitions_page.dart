import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_bar_custom.dart';
import 'package:howth_golf_live/static/app_drawer.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class CompetitionsPage extends StatefulWidget with AppResources {
  final String title = "Competitions";
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return constants.competitionsText;
  }

  @override
  _CompetitionsPageState createState() => new _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> with AppResources {
  /// Use once the backend is complete to request a list of tournaments
/*     
import 'package:dio/dio.dart';

void _getCompetitions() async {
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

  Map _getCompetitions() {
    List tempListCurrent = ['current', 'your', 'competitionssss'];
    List tempListArchived = ['archived', 'your', 'competitionssss'];
    List tempListFavourites = ['favourites', 'your', 'competitionssss'];

    Map<String, List> output = {
      constants.currentText: tempListCurrent,
      constants.archivedText: tempListArchived,
      constants.favouritesText: tempListFavourites
    };

    return output;
  }

  Widget _buildCompetitionsList(
      String _searchText, List filteredCompetitions, List competitions) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        body: DefaultTabController(
            length: 3,
            child: ComplexAppBar(_getCompetitions, _buildCompetitionsList,
                title: constants.competitionsText)));
  }
}
