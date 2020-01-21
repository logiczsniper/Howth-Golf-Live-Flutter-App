import 'package:howth_golf_live/static/fields.dart';

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
  String get values => "$date $location $time $opposition $title $holes $score";

  /// Construct a [DataBaseEntry] from a JSON object.
  ///
  /// The [Firestore] instance will output [_InternalLinkedHashMap]
  /// which must be converted into objects here.
  DataBaseEntry.fromJson(Map map)
      : date = map[Fields.date],
        id = map[Fields.id],
        location = map[Fields.location],
        time = map[Fields.time],
        opposition = map[Fields.opposition],
        title = map[Fields.title],
        holes = List<Hole>.generate(map[Fields.holes].length,
            (int index) => Hole.fromMap(map[Fields.holes][index])),
        score = Score.fromMap(map[Fields.score]);

  /// Converts a database entry into a map so it can be put into the database.
  Map get toJson => {
        Fields.date: date,
        Fields.id: id,
        Fields.location: location,
        Fields.time: time,
        Fields.opposition: opposition,
        Fields.title: title,
        Fields.holes: holes,
        Fields.score: score.toJson
      };

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
      : howth = map[Fields.howth],
        opposition = map[Fields.opposition];

  static Score get fresh => Score(howth: "0", opposition: "0");

  Map get toJson => {Fields.howth: howth, Fields.opposition: opposition};

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
      : holeNumber = map[Fields.holeNumber],
        holeScore = map[Fields.holeScore],
        players = List<String>.generate(map[Fields.players].length,
            (int index) => map[Fields.players][index].toString());

  Map get toJson => {
        Fields.holeNumber: holeNumber,
        Fields.holeScore: holeScore,
        Fields.players: players
      };

  Hole({this.holeNumber, this.holeScore, this.players});
}
