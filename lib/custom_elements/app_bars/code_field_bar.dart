import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/cross_fade.dart';
import 'package:howth_golf_live/static/constants.dart';

class CodeFieldBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Map data;
  final Function applyPrivileges;

  CodeFieldBar(this.data, this.applyPrivileges, {Key key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  CodeFieldBarState createState() =>
      new CodeFieldBarState(data['title']);

  @override
  final Size preferredSize; // default is 56.0
}

class CodeFieldBarState extends State<CodeFieldBar> {
  final TextEditingController _filter = new TextEditingController();
  String _codeText = "";
  bool _toggleAppBar = true;
  Widget _appBarTitle;
  String title;

  CodeFieldBarState(this.title) {
    _appBarTitle = MyCrossFade(title, _filter, 'Enter code here...',
            _toggleAppBar, Icons.keyboard_arrow_right,
            password: true)
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
    widget.applyPrivileges(_codeText.toString());

    setState(() {
      if (this._toggleAppBar == true) {
        _toggleAppBar = false;
      } else {
        _toggleAppBar = true;
        _filter.clear();
      }
      _appBarTitle = MyCrossFade(title, _filter, 'Enter code here...',
              _toggleAppBar, Icons.keyboard_arrow_right,
              password: true)
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
          tooltip: 'Tap to enter a code!',
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
