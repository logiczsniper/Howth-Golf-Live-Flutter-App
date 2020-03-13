import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/services/firebase_interation.dart';
import 'package:howth_golf_live/services/models.dart';

class FirebaseViewModel {
  QuerySnapshot currentSnapshot;

  FirebaseViewModel(this.currentSnapshot);
  FirebaseViewModel.init() : currentSnapshot = null;

  DocumentSnapshot get document => currentSnapshot?.documents?.first;
  List get _documentEntries => document?.data?.entries?.toList();

  List get rawEntries => _documentEntries?.last?.value ?? [];

  List<DataBaseEntry> get databaseEntries => rawEntries
      ?.map((dynamic element) => DataBaseEntry.fromMap(element))
      ?.toList();

  int get adminCode => document?.data[Fields.adminCode];

  DataBaseEntry entryFromId(int id) =>
      databaseEntries?.firstWhere((entry) => entry?.id == id);
  DataBaseEntry entryFromIndex(int index) => databaseEntries?.elementAt(index);

  int bonusEntries(DataBaseEntry currentData) =>
      currentData.holes.length == 0 ? 3 : 2;

  /// Sorts elements into either current or archived lists.
  ///
  /// Will return a list where the element at index 0 is a list of
  /// current [DataBaseEntry]s and the element at index 1 is a list of
  /// archived [DataBaseEntry]s.
  List<List<DataBaseEntry>> sortedElements(
      List<DataBaseEntry> filteredElements) {
    /// All entries are classified as current or archived.
    /// If the [competitionDate] is greater than 9 days in the past,
    /// it is archived. Otherwise, it is current.
    List<DataBaseEntry> currentElements = [];
    List<DataBaseEntry> archivedElements = [];
    for (DataBaseEntry filteredElement in filteredElements) {
      DateTime competitionDate =
          DateTime.parse("${filteredElement.date} ${filteredElement.time}");
      int daysFromNow = competitionDate.difference(DateTime.now()).inDays.abs();

      bool inPast = competitionDate.isBefore(DateTime.now());
      if (daysFromNow >= 8 && inPast) {
        archivedElements.add(filteredElement);
      } else {
        currentElements.add(filteredElement);
      }
    }
    return [currentElements, archivedElements];
  }

  /// Based on the user's [_searchText], filters the competitions.
  ///
  /// Utilizes the [DataBaseEntry.toString] function to get all of the
  /// data for the entry in one string.
  List<DataBaseEntry> filteredElements(String _searchText) {
    List<DataBaseEntry> filteredElements = List();
    if (_searchText.isNotEmpty) {
      databaseEntries.forEach((DataBaseEntry currentEntry) {
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

  static Stream<FirebaseViewModel> get stream => DataBaseInteraction.stream
      .map((querySnapshot) => FirebaseViewModel(querySnapshot));
}
