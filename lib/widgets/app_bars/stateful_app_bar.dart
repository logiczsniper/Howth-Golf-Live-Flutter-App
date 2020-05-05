import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/themes.dart';
import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/connectivity_view_model.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

/// App bar which needs to be able to transform.
///
/// The title converts to a secondary widget on the tap of an
/// icon which also fade transitions to a secondary icon.
///
/// @see [CodeFieldBar], [CompetitionsPageAppBar].
class StatefulAppBar {
  String inputText = Strings.empty;
  String title;
  Widget appBarTitle;
  Widget titleBar;
  Widget inputBar;

  /// Returns the next [appBarTitle].
  Widget actionPressed(
    Widget appBarTitle,
    BuildContext context,
    TextEditingController _filter,
  ) {
    if (appBarTitle == inputBar) {
      _filter.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }
    return appBarTitle == titleBar ? inputBar : titleBar;
  }

  /// Get a custom instantiated [InputDecoration].
  static InputDecoration _getInputDecoration(String hintText) =>
      InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hintText)
          .applyDefaults(Themes.inputDecorationTheme);

  /// The title must be an [AnimatedSwitcher].
  AnimatedSwitcher getTitle(Widget appBarTitle) => AnimatedSwitcher(
      duration: const Duration(milliseconds: 350), child: appBarTitle);

  /// Use the [ConnectivityViewModel] to monitor the status
  /// of the devices connection to internet.
  ///
  /// As all major pages (every page apart from a [HelpPage]), use [StatefulAppBar],
  /// this checks connectivity across nearly the entire app.
  void checkConnectivity(BuildContext context) {
    var _connectivityStatus = Provider.of<ConnectivityViewModel>(context);

    if (_connectivityStatus.isNotConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scaffold.of(context).showSnackBar(UIToolkit.snackbar(
          Strings.noConnection,
          Icons.signal_cellular_connected_no_internet_4_bar,
          duration: const Duration(seconds: 8),
        ));
      });
    }
  }

  /// The simpler app bar that just displays text- the title.
  Widget buildTitleBar(String title, {int id = 0}) {
    if (title == Strings.helpsText || title == Strings.competitionsText)
      return Center(
          child: Text(
        title == Strings.competitionsText ? Strings.empty : title,
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
      ));

    /// At this point, title must be for a specific competition!
    assert(id != 0);
    return Selector<FirebaseViewModel, String>(
      selector: (context, model) => model.entryFromId(id).title,
      builder: (context, title, child) => Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Text(
            title,
            key: ValueKey<String>(title),
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  /// The search app bar which enables the user to type into a search box.
  /// Also the code field input bar.
  Widget buildInputBar(
          TextInputType textType,
          bool obscureText,
          String hintText,
          TextEditingController _filter,
          Function _codePressed) =>
      Container(
          height: 45,
          decoration: BoxDecoration(
            color: Palette.card,
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: TextField(
            keyboardType: textType,
            obscureText: obscureText,
            cursorColor: Palette.maroon,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            controller: _filter,
            style: TextStyle(color: Palette.dark),
            decoration: _getInputDecoration(hintText),
            onSubmitted: (_) => _codePressed(),
          ));
}
