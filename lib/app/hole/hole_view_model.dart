import 'package:howth_golf_live/app/firebase_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/models.dart';

class HoleViewModel {
  FirebaseViewModel _firebaseModel;

  DatabaseEntry databaseEntry(int id) => _firebaseModel.entryFromId(id);

  bool isHome(int id) => databaseEntry(id)?.location?.isHome ?? true;
  String opposition(int id) => databaseEntry(id)?.opposition ?? Strings.empty;
  int holeCount(int id) => databaseEntry(id)?.holes?.length ?? 0;
  List<Hole> holes(int id) => databaseEntry(id)?.holes ?? [];

  Hole hole(int id, int index) =>
      holes(id).length - 1 < index ? null : holes(id).elementAt(index);

  HoleViewModel(this._firebaseModel);

  /// Convert [lastUpdated] to a pretty string.
  String prettyLastUpdated(DateTime lastUpdated) {
    Duration difference = DateTime.now().difference(lastUpdated);

    String value;

    if (difference.inHours < 1)

      /// Less than an hour; return in minutes.
      value = "${difference.inMinutes} minute(s) ago";
    else if (difference.inDays < 1)

      /// Less than a day; return in hours.
      value = "${difference.inHours} hour(s) ago";
    else if (difference.inDays < 365)

      /// Less than a year; return in days.
      value = "${difference.inDays} day(s) ago";
    else

      /// Greater than a year; return in years.
      value = "${(difference.inDays ~/ 365)} year(s) ago";

    return "Last updated: $value";
  }
}
