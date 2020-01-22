import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:howth_golf_live/static/palette.dart';
import 'package:howth_golf_live/widgets/app_bars/stateful_app_bar.dart';
import 'package:howth_golf_live/static/toolkit.dart';

class CompetitionsPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
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

  void _searchPressed() {
    setState(() {
      appBarTitle = actionPressed(appBarTitle, context, _filter);
    });
  }

  @override
  void initState() {
    super.initState();
    titleBar = buildTitleBar(widget.title);
    inputBar = buildInputBar(
        TextInputType.text, false, 'Enter search here...', _filter);
    title = widget.title;
    appBarTitle = titleBar;
    _filter.addListener(() {
      setState(() {
        inputText = _filter.text.isEmpty ? "" : _filter.text;
      });
    });
  }

  AnimatedCrossFade get _iconData => AnimatedCrossFade(
        duration: const Duration(milliseconds: 450),
        firstChild: Icon(Icons.search),
        secondChild: Icon(Icons.close),
        crossFadeState: appBarTitle != inputBar
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      );

  static BubbleTabIndicator get _tabIndicator => BubbleTabIndicator(
      indicatorColor: Palette.maroon,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      indicatorHeight: 25.0,
      insets: EdgeInsets.symmetric(vertical: 1.0, horizontal: 26.0));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
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
                        Toolkit.navigateTo(context, Toolkit.helpText)),
                actions: <Widget>[
                  IconButton(
                    icon: _iconData,
                    tooltip: 'Tap to search!',
                    onPressed: _searchPressed,
                  )
                ],
                bottom: TabBar(
                    labelColor: Palette.dark,
                    indicator: _tabIndicator,
                    tabs: <Widget>[
                      Tab(text: Toolkit.currentText),
                      Tab(text: Toolkit.archivedText)
                    ])),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            widget._listBuilder(inputText, true),
            widget._listBuilder(inputText, false)
          ],
        ),
      ),
    );
  }
}