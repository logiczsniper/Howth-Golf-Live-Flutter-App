import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/cross_fade.dart';
import 'package:howth_golf_live/static/constants.dart';

class CompetitionPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Map data;

  CompetitionPageAppBar(this.data, {Key key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  CompetitionPageAppBarState createState() =>
      new CompetitionPageAppBarState(data['title']);

  @override
  final Size preferredSize; // default is 56.0
}

class CompetitionPageAppBarState extends State<CompetitionPageAppBar> {
  final TextEditingController _filter = new TextEditingController();
  String _codeText = "";
  bool _toggleAppBar = true;
  Widget _appBarTitle;
  String title;

  CompetitionPageAppBarState(this.title) {
    _appBarTitle = MyCrossFade(title, _filter, 'Enter code here...',
            _toggleAppBar, Icons.keyboard_arrow_right)
        .build(context);

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _codeText = "";
        });
      } else {
        setState(() {
          _codeText = _filter.text;
        });
      }
    });
  }

  void _actionPressed() {
    if (_codeText.toString() == widget.data['id'].toString()) {
      print("ENABLED PRIVELDGES");
      // TODO
    }

    setState(() {
      if (this._toggleAppBar == true) {
        _toggleAppBar = false;
      } else {
        _toggleAppBar = true;
        _filter.clear();
      }
      _appBarTitle = MyCrossFade(title, _filter, 'Enter code here...',
              _toggleAppBar, Icons.keyboard_arrow_right)
          .build(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _toggleAppBar = true;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _appBarTitle,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.account_circle),
          tooltip: 'Tap to add to favourites!',
          onPressed: _actionPressed,
          color: Constants.primaryAppColorDark,
        )
      ],
      backgroundColor: Constants.primaryAppColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
    );
  }
}
