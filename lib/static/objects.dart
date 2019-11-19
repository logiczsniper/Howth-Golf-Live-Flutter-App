import 'package:howth_golf_live/static/constants.dart';
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

  String get values {
    return "$date $location $time $opposition $title $holes $score";
  }

  Map convertToMap() {
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

  static DataBaseEntry buildFromMap(Map map) {
    return DataBaseEntry(
        date: map[EntryFields.date],
        id: map[EntryFields.id],
        location: map[EntryFields.location],
        time: map[EntryFields.time],
        opposition: map[EntryFields.opposition],
        title: map[EntryFields.title],
        holes:
            new List<Hole>.generate(map[EntryFields.holes].length, (int index) {
          return Hole.buildFromMap(map[EntryFields.holes][index]);
        }),
        score: Score.buildFromMap(map[EntryFields.score]));
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
  // TODO: specify somewhere here that the date must be in the form:
  // {TWO DIGIT DAY}/{TWO DIGIT MONTH}/{FOUR DIGIT YEAR}
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

  static Score buildFromMap(Map map) {
    return Score(howth: map['howth'], opposition: map['opposition']);
  }

  Score({this.howth, this.opposition});
}

class Hole {
  // TODO: rename all fields for consistency- holeNumber -> hole_number (for example)
  final int holeNumber;
  final String holeScore;
  final List<String> players;

  static Hole buildFromMap(Map map) {
    return Hole(
        holeNumber: map['hole_number'],
        holeScore: map['hole_score'],
        players: new List<String>.generate(map['players'].length, (int index) {
          return map['players'][index].toString();
        }));
  }

  Hole({this.holeNumber, this.holeScore, this.players});
}

class AppHelpEntry {
  final String title;
  final String subtitle;
  final List<HelpStep> steps;

  static AppHelpEntry buildFromMap(Map map) {
    return AppHelpEntry(
        title: map['title'],
        subtitle: map['subtitle'],
        steps: new List<HelpStep>.generate(map['steps'].length, (int index) {
          return HelpStep.buildFromMap(map['steps'][index]);
        }));
  }

  AppHelpEntry({this.title, this.subtitle, this.steps});
}

class HelpStep {
  final String title;
  final String data;
  static HelpStep buildFromMap(Map map) {
    return HelpStep(title: map['title'], data: map['data']);
  }

  HelpStep({this.title, this.data});
}

class Privileges {
  final bool isAdmin;
  final String competitionAccess;

  static Privileges buildFromPreferences(SharedPreferences preferences) {
    return Privileges(
        isAdmin: preferences.getBool(Constants.activeAdminText),
        competitionAccess:
            preferences.getString(Constants.activeCompetitionText));
  }

  Privileges({this.isAdmin, this.competitionAccess});
}
