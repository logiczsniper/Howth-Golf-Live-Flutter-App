import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/services/firebase_interaction.dart';
import 'package:howth_golf_live/services/models.dart';

class FirebaseViewModel {
  QuerySnapshot currentSnapshot;

  FirebaseViewModel(this.currentSnapshot);
  FirebaseViewModel.init() : currentSnapshot = null;

  DocumentSnapshot get document => currentSnapshot?.documents?.first;
  List get _documentEntries => document?.data?.entries?.toList();

  List get rawEntries => _documentEntries?.last?.value ?? [];

  List<DatabaseEntry> get databaseEntries => rawEntries
      ?.map((dynamic element) => DatabaseEntry.fromMap(element))
      ?.toList();

  int get adminCode => document?.data[Fields.adminCode];

  DatabaseEntry entryFromId(int id) =>
      databaseEntries?.firstWhere((entry) => entry?.id == id);
  DatabaseEntry entryFromIndex(int index) => databaseEntries?.elementAt(index);

  int bonusEntries(DatabaseEntry currentData, bool hasVisited) =>
      (currentData.holes.isEmpty ? 3 : (hasVisited ? 2 : 3)) +
      (isArchived(currentData) ? 1 : 0);

  String title(int id) => entryFromId(id)?.title ?? Strings.empty;

  /// Sorts elements into either current or archived lists.
  ///
  /// Will return a list where the element at index 0 is a list of
  /// current [DatabaseEntry]s and the element at index 1 is a list of
  /// archived [DatabaseEntry]s.
  List<List<DatabaseEntry>> sortedElements(
      List<DatabaseEntry> filteredElements) {
    /// All entries are classified as current or archived.
    /// If the [competitionDate] is greater than 9 days in the past,
    /// it is archived. Otherwise, it is current.
    List<DatabaseEntry> currentElements = [];
    List<DatabaseEntry> archivedElements = [];
    for (DatabaseEntry filteredElement in filteredElements) {
      if (isArchived(filteredElement)) {
        archivedElements.add(filteredElement);
      } else {
        currentElements.add(filteredElement);
      }
    }
    return [currentElements, archivedElements];
  }

  /// Determines if the given [DatabaseEntry] is classified as
  /// archived or not.
  bool isArchived(DatabaseEntry filteredElement) {
    DateTime competitionDate =
        DateTime.tryParse(_convertDateFormat(filteredElement));

    /// If we failed to parse the date, set [hoursFromNow] to 0
    /// and [inPast] to true. This moves the competition to current. (we cant
    /// figure out if it is in the past or not).
    int hoursFromNow =
        competitionDate?.difference(DateTime.now())?.inHours?.abs() ?? 0;
    bool inPast = competitionDate?.isBefore(DateTime.now()) ?? true;

    return hoursFromNow >= 25 && inPast;
  }

  /// Based on the user's [_searchText], filters the competitions.
  ///
  /// Utilizes the [DatabaseEntry.toString] function to get all of the
  /// data for the entry in one string.
  List<DatabaseEntry> filteredElements(String _searchText) {
    List<DatabaseEntry> filteredElements = List();
    if (_searchText.isNotEmpty) {
      databaseEntries.forEach((DatabaseEntry currentEntry) {
        String entryString = currentEntry.toString().toLowerCase();
        String query = _searchText.toLowerCase();
        if (entryString.contains(query)) {
          filteredElements.add(currentEntry);
        }
      });
      return filteredElements;
    }
    return databaseEntries;
  }

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

  /// Converts the date format from irish date format (dd-MM-yyyy HH:mm)
  /// to the standard DateTime format (yyyy-MM-dd HH:mm).
  static String _convertDateFormat(DatabaseEntry filteredElement) {
    List<String> _splitDMY = filteredElement.date.split("-");
    return "${_splitDMY[2]}-${_splitDMY[1]}-${_splitDMY[0]} ${filteredElement.time}";
  }

  static Stream<FirebaseViewModel> get stream => FirebaseInteraction.stream
      .map((querySnapshot) => FirebaseViewModel(querySnapshot));
}
