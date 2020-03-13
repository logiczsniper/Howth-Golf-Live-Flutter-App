import 'package:flutter/material.dart';
import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';
import 'package:provider/provider.dart';

class CodeFieldBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final int id;
  final UserStatusViewModel userStatus;

  CodeFieldBar(this.title, this.userStatus, {this.id})
      : preferredSize = Size.fromHeight(56.0);

  @override
  CodeFieldBarState createState() => CodeFieldBarState();

  @override
  final Size preferredSize;
}

class CodeFieldBarState extends State<CodeFieldBar> with StatefulAppBar {
  final TextEditingController _filter = TextEditingController();

  /// Change the app bar, adjust [isVerified] accordingly.
  void _codePressed() {
    var _firebaseModel = Provider.of<FirebaseViewModel>(context, listen: false);
    bool isVerified = widget.userStatus.isVerified(widget.title, id: widget.id);

    if (!isVerified) {
      String codeAttempt = inputText.toString();
      Future<bool> isCodeCorrect = Future.value(false);

      switch (widget.title) {
        case Strings.helpsText:
          isCodeCorrect = widget.userStatus
              .adminAttempt(codeAttempt, _firebaseModel.adminCode.toString());
          break;
        default:
          isCodeCorrect = widget.userStatus
              .managerAttempt(codeAttempt, widget.id.toString());
      }

      isCodeCorrect.then((bool isCodeCorrect) {
        if (!isCodeCorrect && inputText.isNotEmpty)
          Scaffold.of(context)
              .showSnackBar(UIToolkit.snackbar(Strings.incorrectCode));

        setState(() {
          appBarTitle = actionPressed(appBarTitle, context, _filter);
        });
      });
    }
  }

  /// This depends greatly on whether or not the user is verified.
  ///
  /// Both the message and the icon image itself change based on [isVerified].
  IconButton get _actionIconButton {
    bool isVerified = widget.userStatus.isVerified(widget.title, id: widget.id);

    String iconMessage = isVerified ? Strings.alreadyAdmin : Strings.tapCode;
    IconData iconData;

    if (appBarTitle == inputBar) {
      iconData = Icons.check;
    } else {
      iconData = isVerified ? Icons.check_circle_outline : Icons.account_circle;
    }

    return IconButton(
        icon: Icon(iconData),
        tooltip: iconMessage,
        onPressed: _codePressed,
        key: ValueKey(DateTime.now()));
  }

  IconButton get _backIconButton =>
      IconButton(icon: BackButtonIcon(), onPressed: Navigator.of(context).pop);

  @override
  void initState() {
    super.initState();

    /// Build the two bars.
    titleBar = buildTitleBar(widget.title);
    inputBar = buildInputBar(
        TextInputType.number, true, Strings.enterCode, _filter, _codePressed);

    /// Default [appBarTitle] to the title.
    appBarTitle = titleBar;

    _filter.addListener(() =>
        setState(() => inputText = _filter.text.isEmpty ? "" : _filter.text));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: getTitle(appBarTitle),
        centerTitle: true,
        leading: _backIconButton,
        actions: <Widget>[
          AnimatedSwitcher(
              child: _actionIconButton, duration: Duration(milliseconds: 350))
        ]);
  }
}
