import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howth_golf_live/custom_elements/app_bar_custom.dart';
import 'package:howth_golf_live/custom_elements/app_drawer.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class ComplexPage extends StatefulWidget with AppResources {
  final ListTile Function(int index, List filteredElements) _tileBuilder;
  final String title;

  ComplexPage(this._tileBuilder, this.title);

  @override
  _ComplexPageState createState() => new _ComplexPageState();
}

class _ComplexPageState extends State<ComplexPage> with AppResources {
  Widget _buildElementsList(String _searchText, int documentIndex) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(this.widget.title.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
                child: Text("Loading...",
                    style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 187, 187, 187),
                        fontWeight: FontWeight.w400)));

          var elements = snapshot.data.documents[documentIndex].data.entries
              .toList()[0]
              .value;
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
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 1.8,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 248, 248, 248),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: this.widget._tileBuilder(index, filteredElements)),
              );
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
      backgroundColor: appTheme.primaryColor,
    );
  }
}
