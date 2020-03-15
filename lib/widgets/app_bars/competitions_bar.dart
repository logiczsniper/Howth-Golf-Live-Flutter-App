import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/style/text_styles.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';

class CompetitionsPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;

  /// Each tab has its own [_listBuilder] as they are sourced from different
  /// lists- one from current and the other from archived.
  final Widget Function(BuildContext, String, bool) _listBuilder;

  CompetitionsPageAppBar(this._listBuilder, {this.title})
      : preferredSize = Size.fromHeight(56.0);

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
    inputBar = buildInputBar(TextInputType.text, false, Strings.enterSearch,
        _filter, _searchPressed);

    title = widget.title;

    /// [appBarTitle] defaults to the title bar.
    appBarTitle = titleBar;
    _filter.addListener(() =>
        setState(() => inputText = _filter.text.isEmpty ? "" : _filter.text));
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

  AnimatedSwitcher _buildTab(bool isCurrentTab) => AnimatedSwitcher(
      child: widget._listBuilder(context, inputText, isCurrentTab),
      duration: Duration(milliseconds: 350));

  static BubbleTabIndicator get _tabIndicator => BubbleTabIndicator(
      indicatorColor: Palette.maroon,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      indicatorHeight: 29.0,
      indicatorRadius: 13,
      insets: EdgeInsets.zero);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (context, _) => <Widget>[
          SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40))),
              centerTitle: true,
              title: getTitle(appBarTitle),
              floating: true,
              pinned: false,
              snap: true,
              leading: IconButton(
                  icon: Icon(Icons.help_outline),
                  padding: EdgeInsets.fromLTRB(32.0, 8.0, 8.0, 8.0),
                  tooltip: Strings.tapHelp,
                  onPressed: () => Navigator.pushNamed(
                      context, Routes.home + Strings.helpsText)),
              actions: <Widget>[
                IconButton(
                    icon: _iconData,
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 32.0, 8.0),
                    tooltip: Strings.tapSearch,
                    onPressed: _searchPressed)
              ],
              bottom: PreferredSize(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 5.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            child: Text(
                              Strings.competitionsText,
                              style: TextStyles.titleStyle.copyWith(
                                  fontSize: 32.0, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.start,
                            ),
                            padding: EdgeInsets.only(bottom: 6.0),
                          ),
                          TabBar(
                              isScrollable: true,
                              indicator: _tabIndicator,
                              tabs: <Widget>[
                                Tab(text: Strings.currentText),
                                Tab(text: Strings.archivedText)
                              ])
                        ],
                      ),
                    ),
                  ),
                  preferredSize: Size.fromHeight(87.0)))
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
