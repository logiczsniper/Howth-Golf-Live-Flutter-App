import 'package:howth_golf_live/static/toolkit.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DataBaseEntry {
  final String date;
  final int id;
  final String location;
  final String time;
  final String opposition;
  final String title;
  final List<Hole> holes;
  final Score score;

  /// Get a single string which contains all the data specific to this event, making
  /// it easily searchable.
  String get values {
    return "$date $location $time $opposition $title $holes $score";
  }

  /// Construct a [DataBaseEntry] from a JSON object.
  ///
  /// The [Firestore] instance will output [_InternalLinkedHashMap]
  /// which must be converted into objects here.
  DataBaseEntry.fromJson(Map map)
      : date = map[EntryFields.date],
        id = map[EntryFields.id],
        location = map[EntryFields.location],
        time = map[EntryFields.time],
        opposition = map[EntryFields.opposition],
        title = map[EntryFields.title],
        holes =
            new List<Hole>.generate(map[EntryFields.holes].length, (int index) {
          return Hole.fromMap(map[EntryFields.holes][index]);
        }),
        score = Score.fromMap(map[EntryFields.score]);

  /// Converts a database entry into a map so it can be put into the database.
  Map toJson() {
    return {
      EntryFields.date: date,
      EntryFields.id: id,
      EntryFields.location: location,
      EntryFields.time: time,
      EntryFields.opposition: opposition,
      EntryFields.title: title,
      EntryFields.holes: holes,
      EntryFields.score: score
    };
  }

  DataBaseEntry(
      {this.date,
      this.id,
      this.location,
      this.time,
      this.opposition,
      this.title,
      this.holes,
      this.score});
}

class EntryFields {
  /// Note:
  ///
  /// The [date] field below must be in the form '{TWO DIGIT DAY}/{TWO DIGIT MONTH}/{FOUR DIGIT YEAR}'
  static final String date = 'date';
  static final String id = 'id';
  static final String location = 'location';
  static final String time = 'time';
  static final String opposition = 'opposition';
  static final String title = 'title';
  static final String holes = 'holes';
  static final String score = 'score';
}

class Score {
  final String howth;
  final String opposition;

  /// Convert a map to a [Score] object.
  Score.fromMap(Map map)
      : howth = map['howth'],
        opposition = map['opposition'];

  Score({this.howth, this.opposition});
}

class Hole {
  /// Note:
  ///
  /// In the database, [holeNumber] is actually 'hole_number' and
  ///                  [holeScore] is actually 'hole_score'.
  final int holeNumber;
  final String holeScore;
  final List<String> players;

  /// Convert a map into a [Hole] object.
  Hole.fromMap(Map map)
      : holeNumber = map['hole_number'],
        holeScore = map['hole_score'],
        players = new List<String>.generate(map['players'].length, (int index) {
          return map['players'][index].toString();
        });

  Hole({this.holeNumber, this.holeScore, this.players});
}

class AppHelpEntry {
  final String title;
  final String subtitle;
  final List<HelpStep> steps;

  /// Convert a map to a [AppHelpEntry] instance.
  ///
  /// This is used to convert the underlying _appHelpData in [Toolkit] into entries.
  AppHelpEntry.fromMap(Map map)
      : title = map['title'],
        subtitle = map['subtitle'],
        steps = new List<HelpStep>.generate(map['steps'].length, (int index) {
          return HelpStep.fromMap(map['steps'][index]);
        });

  AppHelpEntry({this.title, this.subtitle, this.steps});
}

class HelpStep {
  final String title;
  final String data;

  /// Convert a map into a single [HelpStep] instance.
  HelpStep.fromMap(Map map)
      : title = map['title'],
        data = map['data'];

  HelpStep({this.title, this.data});
}

class Privileges {
  final bool isAdmin;
  final String competitionAccess;

  /// Converting preferences into [Privileges] object.
  Privileges.fromPreferences(SharedPreferences preferences)
      : isAdmin = preferences.getBool(Toolkit.activeAdminText),
        competitionAccess =
            preferences.getString(Toolkit.activeCompetitionText);

  Privileges({this.isAdmin, this.competitionAccess});
}
