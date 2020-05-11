import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

/// An app bar which accepts a passcode.
///
/// [title] the title of the app bar.
///
/// [id] if this is a [CompetitionPage] app bar, this is the [DatabaseEntry.id].
///
/// [backKey], [codeKey] showcase keys.
class CodeFieldBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final int id;
  final UserStatusViewModel userStatus;
  final PreferredSize bottom;
  final GlobalKey backKey;
  final GlobalKey codeKey;

  CodeFieldBar(
    this.title,
    this.userStatus,
    this.backKey,
    this.codeKey, {
    this.id,
    this.bottom,
  })  : preferredSize = Size.fromHeight(bottom == null ? 56.0 : 180.0 + 56.0),
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
          isCodeCorrect = widget.userStatus.adminAttempt(
            codeAttempt,
            _firebaseModel.adminCode.toString(),
          );
          position = Strings.admin;
          break;
        default:
          isCodeCorrect = widget.userStatus
              .managerAttempt(codeAttempt, widget.id.toString());
          position = Strings.manager;
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

  /// The [IconData] switches between a admin icon (if [titleBar]) and
  /// a check icon (if [inputBar]).
  AnimatedCrossFade get _iconData {
    bool isVerified = widget.userStatus.isVerified(widget.title, id: widget.id);
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 350),
      firstChild: Icon(
        isVerified ? Icons.check_circle_outline : Icons.account_circle,
      ),
      secondChild: Icon(Icons.check),
      crossFadeState: appBarTitle != inputBar
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }

  Widget get _backIconButton => UIToolkit.showcase(
      context: context,
      key: widget.backKey,
      description: Strings.tapBack,
      child: IconButton(
          icon: BackButtonIcon(),
          onPressed: Navigator.of(context).pop,
          padding: EdgeInsets.fromLTRB(25.0, 8.0, 5.0, 8.0)));

  Widget _codeIconButton(bool isVerified, bool isHelpsPage) =>
      UIToolkit.showcase(
        context: context,
        key: widget.codeKey,
        description: isHelpsPage ? Strings.tapAdmin : Strings.tapManager,
        child: IconButton(
          icon: _iconData,
          tooltip: isVerified ? Strings.alreadyAdmin : Strings.tapCode,
          onPressed: _codePressed,
          padding: EdgeInsets.fromLTRB(5.0, 8.0, 25.0, 8.0),
        ),
      );

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
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Checks the connection status for the [HelpsPage] and [CompetitionPage].
    checkConnectivity(context);

    bool isVerified = widget.userStatus.isVerified(widget.title, id: widget.id);
    bool isHelpsPage = widget.title == Strings.helpsText;

    return isHelpsPage
        ? AppBar(
            title: getTitle(appBarTitle),
            centerTitle: true,
            leading: _backIconButton,
            actions: <Widget>[_codeIconButton(isVerified, isHelpsPage)],
          )
        : SliverAppBar(
            expandedHeight: 56.0 + 178.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                margin: EdgeInsets.only(top: 56.0),
                child: widget.bottom,
              ),
            ),

            /// Standard [AppBar] attributes.
            title: getTitle(appBarTitle),
            centerTitle: true,
            leading: _backIconButton,
            actions: <Widget>[_codeIconButton(isVerified, isHelpsPage)],
          );
  }
}
