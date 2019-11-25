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
      : date = map[Toolkit.date],
        id = map[Toolkit.id],
        location = map[Toolkit.location],
        time = map[Toolkit.time],
        opposition = map[Toolkit.opposition],
        title = map[Toolkit.title],
        holes = new List<Hole>.generate(map[Toolkit.holes].length, (int index) {
          return Hole.fromMap(map[Toolkit.holes][index]);
        }),
        score = Score.fromMap(map[Toolkit.score]);

  /// Converts a database entry into a map so it can be put into the database.
  Map toJson() {
    return {
      Toolkit.date: date,
      Toolkit.id: id,
      Toolkit.location: location,
      Toolkit.time: time,
      Toolkit.opposition: opposition,
      Toolkit.title: title,
      Toolkit.holes: holes,
      Toolkit.score: score
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
