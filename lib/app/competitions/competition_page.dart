import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/services/utils.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/style/palette.dart';

import 'package:howth_golf_live/widgets/app_bars/code_field_bar.dart';
import 'package:howth_golf_live/widgets/competition_details/competition_details.dart';
import 'package:howth_golf_live/widgets/opacity_change.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

class CompetitionPage extends StatelessWidget {
  final DatabaseEntry initialData;

  CompetitionPage(this.initialData);

  /// Get the styled and positioned widget to display the name of the player(s)
  /// for the designated [hole].
  Expanded _getPlayer(Hole hole, String text, int index, {bool away = false}) =>
      Expanded(
          child: Align(
              alignment: away ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: index % 2 != 0
                          ? Palette.light
                          : Palette.card.withAlpha(240),
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Text(text,
                      textAlign: away ? TextAlign.right : TextAlign.left,
                      style: TextStyles.cardSubTitleTextStyle))));

  /// Gets the properly padded and styled score widget.
  Container _getScore(String text, {bool away = false}) => Container(
      child: Text(text, style: TextStyles.leadingChildTextStyle),
      padding: EdgeInsets.fromLTRB(
          away ? 12.0 : 16.0, 3.0, !away ? 12.0 : 16.0, 3.0));

  /// Constructs a single row in the table of holes.
  ///
  /// This row contains details of one [Hole] as given by [hole].
  /// Depending on [isHome], howth's information will be on the
  /// right or the left.
  ///
  /// The [index] is the index of the [hole] within [currentData], which must be known
  /// when navigating to the individual hole page so that the user can update a single hole-
  /// the hole specified by the index.
  Widget _rowBuilder(BuildContext context, Hole hole, bool isHome,
          String opposition, int index, int id) =>
      GestureDetector(
          child: Padding(
              padding: EdgeInsets.all(5.3),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    /// Home team section.
                    Expanded(
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                          /// Home player.
                          _getPlayer(
                              hole,
                              isHome
                                  ? Utils.formatPlayers(hole.players)
                                  : opposition,
                              index),

                          /// Home score.
                          _getScore(isHome
                              ? hole.holeScore.howth
                              : hole.holeScore.opposition)
                        ])),

                    /// Hole Number
                    UIToolkit.getHoleNumberDecorated(hole.holeNumber),

                    /// Away team section.
                    Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                          /// Away team score.
                          _getScore(
                              !isHome
                                  ? hole.holeScore.howth
                                  : hole.holeScore.opposition,
                              away: true),

                          /// Away team player.
                          _getPlayer(
                              hole,
                              !isHome
                                  ? Utils.formatPlayers(hole.players)
                                  : opposition,
                              index,
                              away: true)
                        ]))
                  ])),
          onTap: () => Routes.toHole(context, id, index));

  @override
  Widget build(BuildContext context) {
    var _userStatus = Provider.of<UserStatusViewModel>(context);
    var _firebaseModel = Provider.of<FirebaseViewModel>(context);

    DatabaseEntry currentData =
        _firebaseModel.entryFromId(initialData.id) ?? initialData;
    bool _hasAccess = _userStatus.isManager(currentData.id);

    Widget floatingActionButton = _hasAccess
        ? UIToolkit.createButton(
            context: context, text: Strings.newHole, id: currentData.id)
        : null;

    return Scaffold(
        floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: floatingActionButton),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar:
            CodeFieldBar(currentData.title, _userStatus, id: currentData.id),
        body: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            child: OpacityChangeWidget(
                key: ValueKey(DateTime.now()),
                target: ListView.separated(
                    padding: EdgeInsets.only(bottom: 100.0),
                    itemCount: currentData.holes.length +
                        _firebaseModel.bonusEntries(currentData),
                    separatorBuilder: (context, index) {
                      if (index != 0 && index != 1)
                        return Divider();
                      else
                        return Container();
                    },
                    itemBuilder: (context, index) {
                      if (index == 0)
                        return CompetitionDetails(currentData);
                      else if (index == 1)
                        return UIToolkit.getVersus(currentData.location.isHome,
                            currentData.opposition, Strings.homeAddress);
                      else if (currentData.holes.length == 0)
                        return Center(
                            child: Padding(
                                child: Text(
                                    "No hole data found for the ${currentData.title}!",
                                    style: TextStyles.noDataTextStyle),
                                padding: EdgeInsets.only(top: 25.0)));
                      else
                        return _rowBuilder(
                            context,
                            currentData.holes[index - 2],
                            currentData.location.isHome,
                            currentData.opposition,
                            index,
                            currentData.id);
                    }))));
  }
}
