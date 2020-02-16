import 'package:howth_golf_live/constants/fields.dart';

class DataBaseEntry {
  final String date;
  final int id;
  final Location location;
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
        location = Location.fromMap(map[Fields.location]),
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
        Fields.location: location.toJson,
        Fields.time: time,
        Fields.opposition: opposition,
        Fields.title: title,
        Fields.holes: List<Map>.generate(
            holes.length, (int index) => holes[index].toJson),
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

  String get leader {
    double howth = double.tryParse(this.howth);
    double opposition = double.tryParse(this.opposition);

    if (howth == null || howth == opposition) {
      /// The teams are all square, [tryParse] returned null.
      return null;
    }

    return howth > opposition ? Fields.howth : Fields.opposition;
  }

  /// Updates the home team in this score by the [value].
  ///
  /// Returns the equivalent hole with the updated value.
  /// [value] will be either 1 or -1 to increment or decrement the home team.
  Score updateScore(bool isHome, int value) {
    int parsedHowth = int.tryParse(howth);
    int parsedOpposition = int.tryParse(opposition);

    Score newScore = Score(
        howth: isHome ? (parsedHowth + value).toString() : howth,
        opposition:
            !isHome ? (parsedOpposition + value).toString() : opposition);

    return newScore;
  }

  Map get toJson => {Fields.howth: howth, Fields.opposition: opposition};

  Score({this.howth, this.opposition});
}

class Hole {
  /// Note:
  ///
  /// In the database, [holeNumber] is actually 'hole_number',
  ///                  [holeScore] is actually 'hole_score' and
  ///                  [lastUpdated] is actually 'last_updated'. (stored as string)
  final int holeNumber;
  final Score holeScore;
  final List<String> players;
  final String comment;
  final DateTime lastUpdated;

  /// Convert a map into a [Hole] object.
  Hole.fromMap(Map map)
      : holeNumber = map[Fields.holeNumber],
        holeScore = Score.fromMap(map[Fields.holeScore]),
        players = List<String>.generate(map[Fields.players].length,
            (int index) => map[Fields.players][index].toString()),
        comment = map[Fields.comment],
        lastUpdated = DateTime.tryParse(map[Fields.lastUpdated]);

  Map get toJson => {
        Fields.holeNumber: holeNumber,
        Fields.holeScore: holeScore.toJson,
        Fields.players: players,
        Fields.comment: comment,
        Fields.lastUpdated: lastUpdated.toString()
      };

  /// Updates this [Hole] instance with the given [value].
  ///
  /// [value] will be -1 or 1, to increment or decrement this [holeNumber].
  /// Furthermore, [lastUpdated] is updated to [DateTime.now]
  Hole updateNumber(int value) => Hole(
      holeNumber: holeNumber + value,
      holeScore: holeScore,
      players: players,
      comment: comment,
      lastUpdated: DateTime.now());

  Hole(
      {this.holeNumber,
      this.holeScore,
      this.players,
      this.comment,
      this.lastUpdated});
}

class Location {
  /// Note:
  ///
  /// In the database, [isHome] is actually 'is_home'.
  final String address;
  final bool isHome;

  /// Convert a map into a [Location] object.
  Location.fromMap(Map map)
      : address = map[Fields.address],
        isHome = map[Fields.isHome];

  Map get toJson => {Fields.address: address, Fields.isHome: isHome};

  Location({this.address, this.isHome});
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
        steps = List<HelpStep>.generate(map['steps'].length,
            (int index) => HelpStep.fromMap(map['steps'][index]));

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