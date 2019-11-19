import 'package:flutter/material.dart';
import 'package:howth_golf_live/custom_elements/app_bars/base.dart';
import 'package:howth_golf_live/custom_elements/buttons/back_button.dart';
import 'package:howth_golf_live/static/constants.dart';

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

class CodeFieldBarState extends State<CodeFieldBar> with AppBarBase {
  final TextEditingController _filter = new TextEditingController();
  bool isVerified;

  void _actionPressed() {
    if (!isVerified) {
      bool isCodeCorrect = widget.applyPrivileges(inputText.toString());

      setState(() {
        // TODO: renmae _actionPressed to be more concise (maybe _codePressed)
        appBarTitle = actionPressed(
            appBarTitle, primaryTitle, secondaryTitle, context, _filter);
        if (!isVerified && isCodeCorrect) {
          isVerified = isCodeCorrect;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: rename thse bars: secondary -> inputBar, primary -> titleBar
    primaryTitle = buildPrimaryBar(widget.title);
    secondaryTitle = buildSecondaryBar(
        TextInputType.number, true, 'Enter code here...', _filter);
    isVerified = widget.isInitVerified;
    title = widget.title;
    appBarTitle = primaryTitle;
    _filter.addListener(() {
      setState(() {
        inputText = _filter.text.isEmpty ? "" : _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String iconMessage =
        isVerified ? 'You are already an Admin!' : 'Tap to enter a code!';
    IconData iconData =
        isVerified ? Icons.check_circle_outline : Icons.account_circle;

    return AppBar(
      title: AnimatedSwitcher(
          duration: Duration(milliseconds: 500), child: appBarTitle),
      centerTitle: true,
      leading: ParameterBackButton(Constants.competitionsText),
      actions: <Widget>[
        // TODO: extract to method. Include the iconMessage and iconData computation in the extraction
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
