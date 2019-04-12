import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bar_custom.dart';
import 'package:howth_golf_live/custom_elements/app_drawer.dart';
import 'package:howth_golf_live/static/app_resources.dart';

class ComplexPage extends StatefulWidget with AppResources {
  final List Function() _currentListBuilder;
  final List Function() _archivedListBuilder;
  final List Function() _favouritesListBuilder;
  final ListTile Function(int index, List filteredElements) _tileBuilder;
  final String title;

  ComplexPage(this._currentListBuilder, this._archivedListBuilder,
      this._favouritesListBuilder, this._tileBuilder, this.title);

  Map _getElements() {
    Map<String, List> output = {
      constants.currentText: _currentListBuilder(),
      constants.archivedText: _archivedListBuilder(),
      constants.favouritesText: _favouritesListBuilder()
    };

    return output;
  }

  @override
  _ComplexPageState createState() => new _ComplexPageState();
}

class _ComplexPageState extends State<ComplexPage> with AppResources {
  Widget _buildElementsList(
      String _searchText, List filteredElements, List elements) {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredElements.length; i++) {
        if (filteredElements[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredElements[i]);
        }
      }
      filteredElements = tempList;
    }
    return ListView.builder(
      itemCount: elements == null ? 0 : filteredElements.length,
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
              child: this.widget._tileBuilder(index, filteredElements)),
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
          child: ComplexAppBar(this.widget._getElements, _buildElementsList,
              title: this.widget.title)),
      backgroundColor: appTheme.primaryColor,
    );
  }
}
