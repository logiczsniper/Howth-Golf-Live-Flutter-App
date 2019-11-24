import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/custom_elements/buttons/back_button.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class CodeFieldBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function applyPrivileges;
  final bool isInitVerified;

  CodeFieldBar(this.title, this.applyPrivileges, this.isInitVerified)
      : preferredSize = Size.fromHeight(56.0);

  @override
  CodeFieldBarState createState() => new CodeFieldBarState();

  @override
  final Size preferredSize;
}

class CodeFieldBarState extends State<CodeFieldBar> with StatefulAppBar {
  final TextEditingController _filter = new TextEditingController();
  bool isVerified;

  void _codePressed() {
    if (!isVerified) {
      bool isCodeCorrect = widget.applyPrivileges(inputText.toString());

      setState(() {
        appBarTitle =
            actionPressed(appBarTitle, titleBar, inputBar, context, _filter);
        if (!isVerified && isCodeCorrect) {
          isVerified = isCodeCorrect;
        }
      });
    }
  }

  IconButton _getIconButton(bool isVerified) {
    String iconMessage =
        isVerified ? 'You are already an Admin!' : 'Tap to enter a code!';
    IconData iconData =
        isVerified ? Icons.check_circle_outline : Icons.account_circle;
    return IconButton(
        icon: Icon(iconData), tooltip: iconMessage, onPressed: _codePressed);
  }

  @override
  void initState() {
    super.initState();
    titleBar = buildTitleBar(widget.title);
    inputBar = buildInputBar(
        TextInputType.number, true, 'Enter code here...', _filter);
    isVerified = widget.isInitVerified;
    title = widget.title;
    appBarTitle = titleBar;
    _filter.addListener(() {
      setState(() {
        inputText = _filter.text.isEmpty ? "" : _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: getTitle(appBarTitle),
      centerTitle: true,
      leading: ParameterBackButton(Toolkit.competitionsText),
      actions: <Widget>[_getIconButton(isVerified)],
      backgroundColor: Toolkit.primaryAppColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Toolkit.primaryAppColorDark),
    );
  }
}
