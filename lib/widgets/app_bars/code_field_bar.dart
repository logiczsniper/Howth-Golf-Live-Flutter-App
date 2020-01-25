import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/widgets/buttons/back_button.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class CodeFieldBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function applyPrivileges;
  final bool isInitVerified;

  CodeFieldBar(this.title, this.applyPrivileges, this.isInitVerified)
      : preferredSize = Size.fromHeight(56.0);

  @override
  CodeFieldBarState createState() => CodeFieldBarState();

  @override
  final Size preferredSize;
}

class CodeFieldBarState extends State<CodeFieldBar> with StatefulAppBar {
  final TextEditingController _filter = TextEditingController();
  bool isVerified;

  /// Change the app bar, adjust [isVerified] accordingly.
  void _codePressed() {
    if (!isVerified) {
      bool isCodeCorrect = widget.applyPrivileges(inputText.toString());

      setState(() {
        appBarTitle = actionPressed(appBarTitle, context, _filter);
        if (!isVerified && isCodeCorrect) {
          isVerified = isCodeCorrect;
        }
      });
    }
  }

  /// This depends greatly on whether or not the user is verified.
  /// TODO: here
  IconButton get _iconButton {
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
      actions: <Widget>[_iconButton],
      backgroundColor: Palette.light,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Palette.dark),
    );
  }
}
