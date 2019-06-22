import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/cross_fade.dart';
import 'package:howth_golf_live/static/constants.dart';

class CodeFieldBar extends StatefulWidget implements PreferredSizeWidget {
  final String dataTitle;
  final Function applyPrivileges;
  final bool isInitVerified;

  CodeFieldBar(this.dataTitle, this.applyPrivileges, this.isInitVerified,
      {Key key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  CodeFieldBarState createState() => new CodeFieldBarState(dataTitle);

  @override
  final Size preferredSize;
}

class CodeFieldBarState extends State<CodeFieldBar> {
  final TextEditingController _filter = new TextEditingController();
  String _codeText = "";
  bool _toggleAppBar = true;
  Widget _appBarTitle;
  String title;
  String iconMessage;
  IconData iconData;
  bool isVerified;

  CodeFieldBarState(this.title) {
    _appBarTitle = MyCrossFade(title, _filter, 'Enter code here...',
            _toggleAppBar, Icons.keyboard_arrow_right, TextInputType.number,
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
    if (!isVerified) {
      bool justVerified = widget.applyPrivileges(_codeText.toString());

      setState(() {
        if (!isVerified && justVerified) {
          this.isVerified = justVerified;
        }

        if (this._toggleAppBar == true) {
          _toggleAppBar = false;
        } else {
          _toggleAppBar = true;
          _filter.clear();
          FocusScope.of(context).requestFocus(new FocusNode());
        }
        _appBarTitle = MyCrossFade(title, _filter, 'Enter code here...',
                _toggleAppBar, Icons.keyboard_arrow_right, TextInputType.number,
                password: true)
            .build(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _toggleAppBar = true;
    isVerified = widget.isInitVerified;
  }

  @override
  Widget build(BuildContext context) {
    iconMessage =
        isVerified ? 'You are already an Admin!' : 'Tap to enter a code!';
    iconData = isVerified ? Icons.check_circle_outline : Icons.account_circle;
    return AppBar(
      title: _appBarTitle,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(iconData),
          tooltip: iconMessage,
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
