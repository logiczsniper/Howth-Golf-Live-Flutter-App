import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CodeFieldBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final int id;
  final UserStatusViewModel userStatus;
  final GlobalKey backKey;
  final GlobalKey codeKey;

  CodeFieldBar(this.title, this.userStatus, this.backKey, this.codeKey,
      {this.id})
      : preferredSize = Size.fromHeight(56.0),
        assert(title == Strings.helpsText ? id == null : id != null);

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
      String position;

      switch (widget.title) {
        case Strings.helpsText:
          isCodeCorrect = widget.userStatus
              .adminAttempt(codeAttempt, _firebaseModel.adminCode.toString());
          position = Strings.admin;
          break;
        default:
          isCodeCorrect = widget.userStatus
              .managerAttempt(codeAttempt, widget.id.toString());
          position = Strings.manager + widget.title + ".";
      }

      isCodeCorrect.then((bool isCodeCorrect) {
        if (!isCodeCorrect && inputText.isNotEmpty)
          Scaffold.of(context).showSnackBar(
              UIToolkit.snackbar(Strings.incorrectCode, Icons.lock));
        else if (isCodeCorrect)
          Scaffold.of(context).showSnackBar(UIToolkit.snackbar(
              Strings.correctCode + position, Icons.lock_open));

        setState(() {
          appBarTitle = actionPressed(appBarTitle, context, _filter);
        });
      });
    }
  }

  /// This depends greatly on whether or not the user is verified.
  ///
  /// Both the message and the icon image itself change based on [isVerified].
  Widget get _actionIconButton {
    bool isVerified = widget.userStatus.isVerified(widget.title, id: widget.id);

    String iconMessage = isVerified ? Strings.alreadyAdmin : Strings.tapCode;
    IconData iconData;

    if (appBarTitle == inputBar) {
      iconData = Icons.check;
    } else {
      iconData = isVerified ? Icons.check_circle : Icons.account_circle;
    }

    String description = widget.title == Strings.helpsText
        ? Strings.tapAdmin
        : Strings.tapManager;

    return UIToolkit.showcase(
        context: context,
        key: widget.codeKey,
        description: description,
        child: IconButton(
            icon: Icon(iconData),
            tooltip: iconMessage,
            onPressed: _codePressed,
            padding: EdgeInsets.fromLTRB(5.0, 8.0, 25.0, 8.0),
            key: ValueKey(DateTime.now())));
  }

  Widget get _backIconButton {
    return UIToolkit.showcase(
        context: context,
        key: widget.backKey,
        description: Strings.tapBack,
        child: IconButton(
            icon: BackButtonIcon(),
            onPressed: Navigator.of(context).pop,
            padding: EdgeInsets.fromLTRB(25.0, 8.0, 5.0, 8.0)));
  }

  @override
  void initState() {
    super.initState();

    /// Build the two bars.
    titleBar = buildTitleBar(widget.title, id: widget.id);
    inputBar = buildInputBar(
        TextInputType.number, true, Strings.enterCode, _filter, _codePressed);

    /// Default [appBarTitle] to the title.
    appBarTitle = titleBar;

    _filter.addListener(() => setState(
        () => inputText = _filter.text.isEmpty ? Strings.empty : _filter.text));
  }

  @override
  Widget build(BuildContext context) {
    checkConnectivity(context);
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
