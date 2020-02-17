import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/widgets/buttons/back_button.dart';

class CodeFieldBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Future<bool> Function(String, int, Function(Future<bool>)) attempt;
  final void Function(Future<bool>) onComplete;
  final int id;
  final bool isInitVerified;

  CodeFieldBar(this.title, this.attempt, this.onComplete, this.isInitVerified,
      {this.id})
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
      String codeAttempt = inputText.toString();

      widget
          .attempt(codeAttempt, widget.id, widget.onComplete)
          .then((bool isCodeCorrect) {
        if (!isCodeCorrect && inputText.isNotEmpty) {
          /// Incorrect [codeAttempt]!

          Scaffold.of(context).showSnackBar(_snackBar);
        }
        setState(() {
          appBarTitle = actionPressed(appBarTitle, context, _filter);
          if (!isVerified && isCodeCorrect) {
            isVerified = isCodeCorrect;
          }
        });
      });
      /* widget.onComplete(inputText.toString()).then((bool isCodeCorrect) {
        if (!isCodeCorrect && inputText.isNotEmpty) {
          /// Incorrect [codeAttempt]!
          final SnackBar snackBar = SnackBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            )),
            backgroundColor: Palette.divider.withAlpha(215),
            content: Text(
              "Incorrect code entered!",
              style: TextStyle(color: Palette.maroon),
              textAlign: TextAlign.center,
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
        setState(() {
          appBarTitle = actionPressed(appBarTitle, context, _filter);
          if (!isVerified && isCodeCorrect) {
            isVerified = isCodeCorrect;
          }
        });
      }); */
    }
  }

  SnackBar get _snackBar => SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        )),
        backgroundColor: Palette.divider.withAlpha(215),
        content: Text(
          "Incorrect code entered!",
          style: TextStyle(color: Palette.maroon),
          textAlign: TextAlign.center,
        ),
      );

  /// This depends greatly on whether or not the user is verified.
  ///
  /// Both the message and the icon image itself change based on [isVerified].
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

    /// Build the two bars.
    titleBar = buildTitleBar(widget.title);
    inputBar = buildInputBar(TextInputType.number, true, 'Enter code here...',
        _filter, _codePressed);

    isVerified = widget.isInitVerified;
    title = widget.title;

    /// Default [appBarTitle] to the title.
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
      leading: ParameterBackButton(Strings.competitionsText),
      actions: <Widget>[_iconButton],
    );
  }
}
