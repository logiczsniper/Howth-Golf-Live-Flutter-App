import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

typedef CompetitionListBuilder = Widget Function(
    BuildContext, String, bool, bool, GlobalKey, GlobalKey, GlobalKey);

class CompetitionsPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;

  /// Each tab has its own [_listBuilder] as they are sourced from different
  /// lists- one from current and the other from archived.
  final CompetitionListBuilder _listBuilder;

  /// Showcase keys.
  final List<GlobalKey> keys;

  /// Whether or not the user has visited before.
  final bool hasVisited;

  CompetitionsPageAppBar(
    this._listBuilder, {
    this.title,
    this.hasVisited,
    this.keys,
  }) : preferredSize = Size.fromHeight(56.0);

  @override
  _CompetitionsPageAppBarState createState() => _CompetitionsPageAppBarState();

  @override
  final Size preferredSize;
}

class _CompetitionsPageAppBarState extends State<CompetitionsPageAppBar>
    with StatefulAppBar {
  final TextEditingController _filter = TextEditingController();

  /// Update the [appBarTitle] to the opposite title.
  void _searchPressed() => setState(
      () => appBarTitle = actionPressed(appBarTitle, context, _filter));

  @override
  void initState() {
    super.initState();

    /// Build the two bars.
    titleBar = buildTitleBar(widget.title);
    inputBar = buildInputBar(
      TextInputType.text,
      false,
      Strings.enterSearch,
      _filter,
      _searchPressed,
    );

    title = widget.title;

    /// [appBarTitle] defaults to the title bar.
    appBarTitle = titleBar;
    _filter.addListener(
      () => setState(() =>
          inputText = _filter.text.isEmpty ? Strings.empty : _filter.text),
    );
  }

  /// The [IconData] switches between a search icon (if [titleBar]) and
  /// a close icon (if [inputBar]).
  AnimatedCrossFade get _iconData => AnimatedCrossFade(
        duration: const Duration(milliseconds: 350),
        firstChild: Icon(Icons.search),
        secondChild: Icon(Icons.close),
        crossFadeState: appBarTitle != inputBar
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      );

  /// Build the tab - the list of competitions!
  Widget _buildTab(bool isCurrentTab) => widget._listBuilder(
        context,
        inputText,
        isCurrentTab,
        widget.hasVisited,
        widget.keys[4],
        widget.keys[5],
        widget.keys[6],
      );

  static BubbleTabIndicator get _tabIndicator => BubbleTabIndicator(
      indicatorColor: Palette.maroon,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      indicatorHeight: 29.0,
      indicatorRadius: 13,
      insets: EdgeInsets.zero);

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Checks the connectivity for the [CompetitionsPage].
    checkConnectivity(context);

    return SafeArea(
      child: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (context, _) => <Widget>[
          SliverAppBar(
            centerTitle: true,
            title: getTitle(appBarTitle),
            floating: true,
            pinned: false,
            snap: true,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(13))),
            leading: UIToolkit.showcase(
              context: context,
              key: widget.keys[1],
              description: Strings.tapHelp,
              child: IconButton(
                  icon: Icon(Icons.help_outline),
                  padding: EdgeInsets.fromLTRB(27.0, 8.0, 8.0, 8.0),
                  tooltip: Strings.tapHelp,
                  onPressed: () => Routes.of(context).toHelps()),
            ),
            actions: <Widget>[
              UIToolkit.showcase(
                  context: context,
                  key: widget.keys[0],
                  description: Strings.tapSearch,
                  child: IconButton(
                      icon: _iconData,
                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 27.0, 8.0),
                      tooltip: Strings.tapSearch,
                      onPressed: _searchPressed))
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(87.0),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(28.0, 5.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        Strings.competitionsText,
                        textAlign: TextAlign.start,
                        style: TextStyles.title.copyWith(
                          fontSize: 33.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TabBar(
                        isScrollable: true,
                        indicator: _tabIndicator,
                        tabs: <Widget>[
                          UIToolkit.showcase(
                              context: context,
                              key: widget.keys[2],
                              description: Strings.currentWelcome,
                              child: Tab(text: Strings.currentText)),
                          UIToolkit.showcase(
                              context: context,
                              key: widget.keys[3],
                              description: Strings.archivedWelcome,
                              child: Tab(text: Strings.archivedText)),
                        ])
                  ],
                ),
              ),
            ),
          )
        ],
        body: TabBarView(children: <Widget>[
          /// The second parameter indicates whether or not this
          /// list builder is for current events or archived.
          _buildTab(true),
          _buildTab(false)
        ]),
      ),
    );
  }
}
