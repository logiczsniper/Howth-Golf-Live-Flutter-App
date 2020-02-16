import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/palette.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';

class CompetitionsPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;

  /// Each tab has its own [_listBuilder] as they are sourced from different
  /// lists- one from current and the other from archived.
  final Function _listBuilder;

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
  void _searchPressed() {
    setState(() {
      appBarTitle = actionPressed(appBarTitle, context, _filter);
    });
  }

  @override
  void initState() {
    super.initState();

    /// Build the two bars.
    titleBar = buildTitleBar(widget.title);
    inputBar = buildInputBar(TextInputType.text, false, 'Enter search here...',
        _filter, _searchPressed);

    title = widget.title;

    /// [appBarTitle] defaults to the title bar.
    appBarTitle = titleBar;
    _filter.addListener(() {
      setState(() {
        inputText = _filter.text.isEmpty ? "" : _filter.text;
      });
    });
  }

  /// The [IconData] switches between a search icon (if [titleBar]) and
  /// a close icon (if [inputBar]).
  AnimatedCrossFade get _iconData => AnimatedCrossFade(
        duration: const Duration(milliseconds: 450),
        firstChild: Icon(Icons.search),
        secondChild: Icon(Icons.close),
        crossFadeState: appBarTitle != inputBar
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      );

  /// Get a custom instantiated [BubbleTabIndicator].
  static BubbleTabIndicator get _tabIndicator => BubbleTabIndicator(
      indicatorColor: Palette.maroon,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      indicatorHeight: 70.0,
      indicatorRadius: 15.0,
      insets: EdgeInsets.symmetric(vertical: 1.0, horizontal: 40.0));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                )),
                centerTitle: true,
                title: getTitle(appBarTitle),
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: Palette.light,
                iconTheme: IconThemeData(color: Palette.dark),
                leading: IconButton(
                    icon: Icon(Icons.help_outline),
                    tooltip: 'Tap for help!',
                    onPressed: () =>
                        Routes.navigateTo(context, Strings.helpText)),
                actions: <Widget>[
                  IconButton(
                    icon: _iconData,
                    tooltip: 'Tap to search!',
                    onPressed: _searchPressed,
                  )
                ],
                bottom: TabBar(
                    labelColor: Palette.buttonText,
                    indicator: _tabIndicator,
                    tabs: <Widget>[
                      Tab(
                          icon: Icon(Icons.whatshot),
                          text: Strings.currentText),
                      Tab(text: Strings.archivedText, icon: Icon(Icons.cached))
                    ])),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            /// The second parameter indicates whether or not this
            /// list builder is for current events or archived.
            AnimatedSwitcher(
                child: widget._listBuilder(inputText, true),
                duration: Duration(seconds: 1)),
            AnimatedSwitcher(
                child: widget._listBuilder(inputText, false),
                duration: Duration(seconds: 1))
          ],
        ),
      ),
    );
  }
}
