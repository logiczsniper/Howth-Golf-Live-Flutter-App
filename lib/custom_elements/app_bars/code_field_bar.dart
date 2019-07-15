import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/back_button.dart';
import 'package:howth_golf_live/custom_elements/fade_animations/cross_fade.dart';
import 'package:howth_golf_live/static/constants.dart';

class CodeFieldBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function applyPrivileges;
  final bool isInitVerified;

  CodeFieldBar(this.title, this.applyPrivileges, this.isInitVerified)
      : preferredSize = Size.fromHeight(56.0);

  @override
  CodeFieldBarState createState() => new CodeFieldBarState(title);

  @override
  final Size preferredSize;
}

class CodeFieldBarState extends State<CodeFieldBar> {
  final TextEditingController _filter = new TextEditingController();
  String codeText = "";
  String title;
  bool _toggleAppBar = true;
  bool isVerified;

  CodeFieldBarState(this.title) {
    _filter.addListener(() {
      setState(() {
        codeText = _filter.text.isEmpty ? "" : _filter.text;
      });
    });
  }

  void _actionPressed() {
    if (!isVerified) {
      bool isCodeCorrect = widget.applyPrivileges(codeText.toString());

      setState(() {
        if (!isVerified && isCodeCorrect) {
          isVerified = isCodeCorrect;
        }

        _toggleAppBar = !_toggleAppBar;

        if (_toggleAppBar) {
          _filter.clear();
          FocusScope.of(context).requestFocus(new FocusNode());
        }
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
    String iconMessage =
        isVerified ? 'You are already an Admin!' : 'Tap to enter a code!';
    IconData iconData =
        isVerified ? Icons.check_circle_outline : Icons.account_circle;
    Widget _appBarTitle = TitleCrossFade(_filter, _toggleAppBar,
        title: title,
        hintText: 'Enter code here...',
        iconData: Icons.keyboard_arrow_right,
        textInputType: TextInputType.number,
        password: true);

    return AppBar(
      title: _appBarTitle,
      centerTitle: true,
      leading: MyBackButton(Constants.competitionsText),
      actions: <Widget>[
        IconButton(
            icon: Icon(iconData),
            tooltip: iconMessage,
            onPressed: _actionPressed)
      ],
      backgroundColor: Constants.primaryAppColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Constants.primaryAppColorDark),
    );
  }
}
