import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:howth_golf_live/custom_elements/app_bar.dart';
import 'package:howth_golf_live/custom_elements/app_drawer.dart';
import 'package:howth_golf_live/custom_elements/complex_card.dart';
import 'package:howth_golf_live/pages/specific_competition.dart';
import 'package:howth_golf_live/static/constants.dart';

class ComplexPage extends StatefulWidget {
  final Widget Function(int index, List filteredElements) _tileBuilder;
  final String title;

  ComplexPage(this._tileBuilder, this.title);

  @override
  _ComplexPageState createState() => new _ComplexPageState();
}

class _ComplexPageState extends State<ComplexPage> {
  Widget _complexTileBuilder(int index, List filteredElements) {
    if (filteredElements == null)
      return ListTile(
          title: Center(
              child: SpinKitPulse(
        color: Constants.primaryAppColorDark,
        size: 45,
        duration: Duration(milliseconds: 800),
      )));

    if (filteredElements[0] is bool)
      return ListTile(
          title: Center(
              child: Text("No ${widget.title.toLowerCase()} found!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontWeight: FontWeight.w300))));

    return this.widget._tileBuilder(index, filteredElements);
  }

  // TODO build an AnimatedList instead- fade effect to elements
  Widget _buildElementsList(String _searchText, int documentIndex) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(this.widget.title.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: SpinKitPulse(
              color: Constants.primaryAppColorDark,
            ));

          var elements =
              snapshot.data.documents[2].data.entries.toList()[0].value;
          List filteredElements = elements;

          if (_searchText.isNotEmpty) {
            List tempList = new List();
            for (int i = 0; i < elements.length; i++) {
              if (elements[i]
                  .values
                  .join()
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
                tempList.add(elements[i]);
              }
            }
            filteredElements = tempList.isNotEmpty ? tempList : [false];
          }

          return ListView.builder(
            itemCount: filteredElements.length,
            itemBuilder: (BuildContext context, int index) {
              return ComplexCard(_complexTileBuilder(index, filteredElements),
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SpecificCompetitionPage(filteredElements[index])));
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: DefaultTabController(
          length: 3,
          child: ComplexAppBar(_buildElementsList, title: this.widget.title)),
      backgroundColor: Constants.primaryAppColor,
    );
  }
}
