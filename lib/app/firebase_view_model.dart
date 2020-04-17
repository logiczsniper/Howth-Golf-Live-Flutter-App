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
      databaseEntries?.firstWhere((entry) => entry?.id == id,
          orElse: () => DatabaseEntry.empty);

  List<DatabaseEntry> activeElements(
      bool hasVisited, bool isCurrentTab, String searchText) {
    List<DatabaseEntry> filteredElements = filterElements(searchText);

    /// At the 0th index of [sortedElements] will be the currentElements,
    /// and at the 1st index will be the archivedElements.
    List<List<DatabaseEntry>> sortedElements = sortElements(filteredElements);

    List<DatabaseEntry> activeElements =
        isCurrentTab ? sortedElements[0] : sortedElements[1];

    return activeElements;
  }

  int competitionsItemCount(
      bool hasVisited, bool isCurrentTab, String searchText) {
    List<DatabaseEntry> _activeElements =
        activeElements(hasVisited, isCurrentTab, searchText);

    int itemCount = _activeElements.isEmpty
        ? 1
        : (hasVisited || !isCurrentTab
            ? _activeElements.length
            : _activeElements.length + 1);

    return itemCount;
  }

  int holesItemCount(int id, bool hasVisited) {
    DatabaseEntry currentData = entryFromId(id);
    List<Hole> holes = currentData.holes;

    if (!hasVisited) {
      return holes.length + 2;
    } else {
      if (holes.isEmpty)
        return 2;
      else
        return holes.length + 1;
    }
  }

  String title(int id) => entryFromId(id)?.title ?? Strings.empty;

  /// Sorts elements into either current or archived lists.
  ///
  /// Will return a list where the element at index 0 is a list of
  /// current [DatabaseEntry]s and the element at index 1 is a list of
  /// archived [DatabaseEntry]s.
  List<List<DatabaseEntry>> sortElements(List<DatabaseEntry> filteredElements) {
    /// All entries are classified as current or archived.
    /// If the [competitionDate] is greater than 9 days in the past,
    /// it is archived. Otherwise, it is current.
    List<DatabaseEntry> currentElements = [];
    List<DatabaseEntry> archivedElements = [];
    for (DatabaseEntry filteredElement in filteredElements) {
      if (filteredElement.isArchived) {
        archivedElements.add(filteredElement);
      } else {
        currentElements.add(filteredElement);
      }
    }
    return [currentElements, archivedElements];
  }

  /// Based on the user's [_searchText], filters the competitions.
  ///
  /// Utilizes the [DatabaseEntry.toString] function to get all of the
  /// data for the entry in one string.
  List<DatabaseEntry> filterElements(String _searchText) {
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

  static Stream<FirebaseViewModel> get stream => FirebaseInteraction.stream
      .map((querySnapshot) => FirebaseViewModel(querySnapshot));
}
