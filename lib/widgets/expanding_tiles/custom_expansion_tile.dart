import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:howth_golf_live/app/firebase_view_model.dart';
import 'package:howth_golf_live/app/modification/modify_hole.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
import 'package:howth_golf_live/services/models.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/alert_dialog.dart';
import 'package:howth_golf_live/widgets/expanding_tiles/icon_button_pair.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

/// Logan Czernel - modification to [ExpansionTile].
///
/// This is literally the same widget as a standard [ExpansionTile],
/// however without the [trailing] property. I needed to remove it
/// entirely in order for there to be no spacing/padding on the right
/// side of my [CustomExpansionTile].
///
/// @see C:\flutter_install\flutter\packages\flutter\lib\src\material\expansion_tile.dart

const Duration _kExpand = const Duration(milliseconds: 350);

class CustomExpansionTile extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const CustomExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
    this.index,
    this.id,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget subtitle;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  final int index;
  final int id;

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  final ColorTween _borderColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));

    _isExpanded = widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            textColor: Palette.dark,
            child: ListTile(
              onTap: _handleTap,
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _borderColorTween..end = Palette.card;
    super.didChangeDependencies();
  }

  Widget get _adminWidgets =>
      Selector2<UserStatusViewModel, FirebaseViewModel, bool>(
        selector: (context, userStatusModel, firebaseModel) =>
            firebaseModel.entryFromId(widget.id).isArchived
                ? userStatusModel.isAdmin
                : userStatusModel.isManager(widget.id),
        builder: (context, hasAccess, child) => hasAccess
            ? Stack(
                children: <Widget>[
                  /// Close this hole!
                  Container(
                    margin: EdgeInsets.only(right: 27.0),
                    padding:
                        EdgeInsets.only(bottom: 4.0, left: 0.5, right: 0.5),
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _handleTap,
                      child: Icon(Icons.highlight_off, size: 33.25),
                    ),
                  ),

                  /// Modify/delete the hole!
                  Container(
                    margin: EdgeInsets.only(left: 27.0),
                    padding:
                        EdgeInsets.only(bottom: 4.0, left: 0.5, right: 0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => showModal(
                            context: context,
                            configuration: UIToolkit.modalConfiguration(),
                            builder: (context) =>
                                ModifyHole(widget.id, widget.index),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 32.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showModal(
                            context: context,
                            configuration:
                                UIToolkit.modalConfiguration(isDeletion: true),
                            builder: (context) => CustomAlertDialog(
                              FirebaseInteraction.of(context).deleteHole,
                              index: widget.index,
                              id: widget.id,
                            ),
                          ),
                          child: Icon(
                            Icons.delete,
                            size: 32.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// Modify howth's score!
                      IconButtonPair(context, widget.index, widget.id,
                          onAdd: (currentHole) {
                        Score updatedScore =
                            currentHole.holeScore.updateScore(true, 1);
                        Hole updatedHole =
                            currentHole.updateHole(newScore: updatedScore);
                        return updatedHole;
                      }, onSubtract: (currentHole) {
                        Score updatedScore =
                            currentHole.holeScore.updateScore(true, -1);
                        Hole updatedHole =
                            currentHole.updateHole(newScore: updatedScore);
                        return updatedHole;
                      }),

                      /// Modify the hole number!
                      IconButtonPair(context, widget.index, widget.id,
                          iconColor: Palette.maroon, onAdd: (currentHole) {
                        Hole updatedHole = currentHole.updateNumber(1);
                        return updatedHole;
                      }, onSubtract: (currentHole) {
                        Hole updatedHole = currentHole.updateNumber(-1);
                        return updatedHole;
                      }),

                      /// Modify the opposition score!
                      IconButtonPair(context, widget.index, widget.id,
                          onAdd: (currentHole) {
                        Score updatedScore =
                            currentHole.holeScore.updateScore(false, 1);
                        Hole updatedHole =
                            currentHole.updateHole(newScore: updatedScore);
                        return updatedHole;
                      }, onSubtract: (currentHole) {
                        Score updatedScore =
                            currentHole.holeScore.updateScore(false, -1);
                        Hole updatedHole =
                            currentHole.updateHole(newScore: updatedScore);
                        return updatedHole;
                      }),
                    ],
                  ),
                ],
              )
            : Container(),
      );

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;

    List<Widget> children = widget.children;
    children.insert(0, _adminWidgets);
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
