import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/app_bar_complex.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class CompetitionsPage extends StatefulWidget with AppResources {
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

  List _getCompetitions() {
    List tempList = ['bobs', 'your', 'competitions'];
    return tempList;
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
        body: DefaultTabController(
            length: 3,
            child: ComplexAppBar(_getCompetitions, _buildCompetitionsList,
                title: constants.competitionsText)));
  }
}
