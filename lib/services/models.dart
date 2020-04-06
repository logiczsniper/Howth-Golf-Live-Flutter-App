import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:meta/meta.dart';

abstract class Model {
  Map<String, dynamic> get toJson;
  fromJson(Map<String, dynamic> json);

  List<T> generateList<T extends Model>(List<Map<String, dynamic>> source) =>
      List<T>.generate(source.length, (int i) => fromJson(source[i]));
}

class DatabaseEntry {
  final int id;
  final Location location;
  final String date;
  final String time;
  final String opposition;
  final String title;
  final List<Hole> holes;
  final Score score;

  /// Get a single string which contains all the data specific to this event, making
  /// it easily searchable.
  @override
  String toString() => "$date $location $time $opposition $title $holes $score";

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is DatabaseEntry && other.id == id;

  /// Construct a [DatabaseEntry] from a JSON object.
  ///
  /// The [Firestore] instance will output [_InternalLinkedHashMap]
  /// which must be converted into objects here.
  DatabaseEntry.fromMap(Map map)
      : date = map[Fields.date],
        id = map[Fields.id],
        location = Location.fromMap(map[Fields.location]),
        time = map[Fields.time],
        opposition = map[Fields.opposition],
        title = map[Fields.title],
        holes = List<Hole>.generate(map[Fields.holes].length,
            (int index) => Hole.fromMap(map[Fields.holes][index])),
        score = Score.fromMap(map[Fields.score]);

  static DatabaseEntry get example => DatabaseEntry(
      date:
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      id: -1,
      location: Location.example,
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      opposition: "Opposing Club Name",
      title: "Example Competition Title",
      holes: [Hole.example],
      score: Score.example);

  /// Converts a database entry into a map so it can be put into the database.
  Map<String, dynamic> get toJson => {
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

  DatabaseEntry(
      {@required this.date,
      @required this.id,
      @required this.location,
      @required this.time,
      @required this.opposition,
      @required this.title,
      @required this.holes,
      @required this.score});
}

class Score {
  final String howth;
  final String opposition;

  /// Convert a map to a [Score] object.
  Score.fromMap(Map map)
      : howth = map[Fields.howth],
        opposition = map[Fields.opposition];

  /// Convert a list of [Hole] data to a [Score] object.
  ///
  /// Get the updated competition score with the new hole scores,
  /// [parsedHoles], and format the score based on whether
  /// or not the scores are floats.
  Score.fromParsedHoles(List<Hole> parsedHoles)
      : assert(_calculateScore(parsedHoles).length == 2),
        howth = _calculateScore(parsedHoles)[0],
        opposition = _calculateScore(parsedHoles)[1];

  static Score get example => Score(howth: "1", opposition: "0");
  static Score get holeExample => Score(howth: "4", opposition: "0");

  static Score get fresh => Score(howth: "0", opposition: "0");

  /// Calculates the overall score of the [parsedHoles].
  ///
  /// Returns [howth] score at the 0th index, and
  /// [opposition] score at the 1st index.
  static List<String> _calculateScore(List<Hole> parsedHoles) {
    double parsedHowth = 0;
    double parsedOpposition = 0;
    for (Hole hole in parsedHoles) {
      if (hole.holeScore.howth == hole.holeScore.opposition &&
          hole.holeScore.howth == "0") {
        /// The match is all square: do nothing with score!
      } else if (hole.holeScore._leader == Fields.howth) {
        parsedHowth++;
      } else if (hole.holeScore._leader == Fields.opposition) {
        parsedOpposition++;
      } else {
        /// Its a draw- both go up by 0.5!
        parsedHowth += 0.5;
        parsedOpposition += 0.5;
      }
    }

    /// If the scores are whole numbers, parse to int before making the output.
    List<String> calculatedScore = parsedHowth - parsedHowth.toInt() != 0
        ? [parsedHowth.toString(), parsedOpposition.toString()]
        : [parsedHowth.toInt().toString(), parsedOpposition.toInt().toString()];

    return calculatedScore;
  }

  bool get isAllSquare => howth == opposition && howth == "0";

  String get _leader {
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
  /// [value] will be either 1 or -1 to increment or decrement howth's score.
  Score updateScore(bool isHowth, int value) {
    assert(value == 1 || value == -1);
    int parsedHowth = int.tryParse(howth);
    int parsedOpposition = int.tryParse(opposition);

    Score newScore = Score(
        howth: isHowth ? (parsedHowth + value).toString() : howth,
        opposition:
            !isHowth ? (parsedOpposition + value).toString() : opposition);

    return newScore;
  }

  Map get toJson => {Fields.howth: howth, Fields.opposition: opposition};

  @override
  String toString() => "Howth: $howth, Opposition: $opposition";

  @override
  int get hashCode => this.toString().hashCode;

  @override
  bool operator ==(Object other) =>
      other is Score && other.howth == howth && other.opposition == opposition;

  Score({@required this.howth, @required this.opposition});
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
  final List<String> opposition;
  final String comment;
  final DateTime lastUpdated;

  /// Convert a map into a [Hole] object.
  Hole.fromMap(Map map)
      : holeNumber = map[Fields.holeNumber],
        holeScore = Score.fromMap(map[Fields.holeScore]),
        players = List<String>.generate(map[Fields.players].length,
            (int index) => map[Fields.players][index].toString()),
        opposition = List<String>.generate(map[Fields.opposition].length,
            (int index) => map[Fields.opposition][index].toString()),
        comment = map[Fields.comment],
        lastUpdated = DateTime.tryParse(map[Fields.lastUpdated]);

  static Hole get example => Hole(
      holeNumber: 2,
      holeScore: Score.holeExample,
      players: ["Home player(s)"],
      opposition: ["Opposing club/player(s)"],
      comment: Strings.empty,
      lastUpdated: DateTime.now().subtract(Duration(seconds: 60)));

  static Hole get fresh => Hole(
      holeNumber: 0,
      holeScore: Score.fresh,
      players: [Strings.empty],
      opposition: [Strings.empty],
      comment: Strings.empty,
      lastUpdated: DateTime.now());

  Map get toJson => {
        Fields.holeNumber: holeNumber,
        Fields.holeScore: holeScore.toJson,
        Fields.players: players,
        Fields.opposition: opposition,
        Fields.comment: comment,
        Fields.lastUpdated: lastUpdated.toString()
      };

  /// Updates this [Hole] instance with the given [value].
  ///
  /// [value] will be -1 or 1, to increment or decrement this [holeNumber].
  /// Furthermore, [lastUpdated] is updated to [DateTime.now]
  Hole updateNumber(int value) {
    assert(value == 1 || value == -1);
    return Hole(
        holeNumber: holeNumber + value,
        holeScore: holeScore,
        players: players,
        opposition: opposition,
        comment: comment,
        lastUpdated: DateTime.now());
  }

  Hole updateHole(
      {Score newScore,
      int newHoleNumber,
      List<String> newPlayers,
      List<String> newOpposition,
      String newComment}) {
    assert(newScore != null ||
        newHoleNumber != null ||
        newPlayers != null ||
        newComment != null ||
        newOpposition != null);
    return Hole(
        holeNumber: newHoleNumber ?? holeNumber,
        holeScore: newScore ?? holeScore,
        players: newPlayers ?? players,
        opposition: newOpposition ?? opposition,
        comment: newComment ?? comment,
        lastUpdated: DateTime.now());
  }

  String get formattedPlayers => _formattedNames(players).isEmpty
      ? Strings.homeAddress
      : _formattedNames(players);
  String formattedOpposition(String oppositionClub) =>
      _formattedNames(opposition).isEmpty
          ? oppositionClub
          : _formattedNames(opposition);

  /// Turn a list of players, [playerList], into one string with
  /// those individual player names separated by commas, apart from the last
  /// player in the list.
  String _formattedNames(List<String> names) => names.fold(
      names.first,
      (String first, String second) =>
          second == names.first ? first : first + ", " + second);

  @override
  int get hashCode => lastUpdated.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Hole && other.lastUpdated.isAtSameMomentAs(lastUpdated);

  Hole(
      {@required this.holeNumber,
      @required this.holeScore,
      @required this.players,
      this.comment,
      this.opposition,
      @required this.lastUpdated});
}

class Location {
  /// Note:
  ///
  /// In the database, [isHome] is actually 'is_home'.
  final String address;

  /// Convert a map into a [Location] object.
  Location.fromMap(Map map) : address = map[Fields.address];

  Map get toJson => {Fields.address: address};

  bool get isHome => address == Strings.homeAddress;

  static Location get example => Location(address: Strings.homeAddress);

  @override
  int get hashCode => address.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Location && other.address == address;

  Location({@required this.address});
}

class AppHelpEntry {
  final String title;
  final String subtitle;
  final List<HelpStep> steps;

  /// Convert a map to a [AppHelpEntry] instance.
  ///
  /// This is used to convert the underlying _appHelpData in [Toolkit] into entries.
  AppHelpEntry.fromMap(Map map)
      : title = map[Fields.title],
        subtitle = map[Fields.subtitle],
        steps = List<HelpStep>.generate(map[Fields.steps].length,
            (int index) => HelpStep.fromMap(map[Fields.steps][index]));

  AppHelpEntry(
      {@required this.title, @required this.subtitle, @required this.steps});
}

class HelpStep {
  final String title;
  final String data;

  /// Convert a map into a single [HelpStep] instance.
  HelpStep.fromMap(Map map)
      : title = map[Fields.title],
        data = map[Fields.data];

  HelpStep({@required this.title, @required this.data});
}
