import 'package:flutter/material.dart';
import 'package:howth_golf_live/pages/parents/simple_page.dart';

class ClubLinksPage extends SimplePage {
  static Center buildBody() {
    return Center(child: Text('Club Links page'));
  }

  ClubLinksPage({Key key}) : super(buildBody, "Club Links", key: key);
}
