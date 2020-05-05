import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';

class HelpDataViewModel {
  /// The data fetched from [assets/help_data.json].
  List<AppHelpEntry> _helpData;

  List<AppHelpEntry> get data => _helpData ?? [];

  HelpDataViewModel(this._helpData);
  HelpDataViewModel.init() : _helpData = null;

  /// Fetch the data from assets.
  static Future<HelpDataViewModel> get getModel async {
    final parsed = await rootBundle.loadString(Strings.helpData);

    List<Map<String, dynamic>> result =
        json.decode(parsed).cast<Map<String, dynamic>>();

    List<AppHelpEntry> _helpData =
        result.map((Map data) => AppHelpEntry.fromMap(data)).toList();

    return HelpDataViewModel(_helpData);
  }
}
