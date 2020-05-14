import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/constants/strings.dart';
import 'package:meta/meta.dart';

/// Represents a competition in the database.
///
/// [id] is an immutable, 6 digit integer which is used as the code to gain access to
/// the competition entry.
///
/// [opposition] the opposing team name.
///
/// [score] the overall competition score.
class DatabaseEntry {
  final int id;
  final Location location;
  final String date;
  final String time;
  final String opposition;
  final String title;
  final List<Hole> holes;
  final Score score;

  static DatabaseEntry get example => DatabaseEntry(
      date: "01-02-2020",
      id: -1,
      location: Location.example,
      time: "12:00",
      opposition: "Opposing Club Name",
      title: "Example Competition Title",
      holes: [Hole.example],
      score: Score.example);

  static DatabaseEntry get empty => DatabaseEntry(
        date: "00-00-0000",
        id: -2,
        location: Location.empty,
        time: "00:00",
        opposition: Strings.empty,
        title: Strings.empty,
        holes: [],
        score: Score.empty,
      );

  /// Calculate the approximate height addition for the [CodeFieldBar] that is required
  /// to prevent overflow.
  double get codeBarHeightAddon {
    if (isArchived && longOppositionName)
      return 223.0;
    else if (isArchived)
      return 214.0;
    else if (longOppositionName)
      return 184.0;
    else
      return 178.0;
  }

  /// Fetch an attribute based on [field] String.
  String attribute(String field) {
    switch (field) {
      case Fields.address:
        return location.address;
      case Fields.date:
        return date;
      case Fields.time:
        return time;
      case Fields.id:
        return id.toString();
      default:
        throw AssertionError();
    }
  }

  /// Determines if the given [DatabaseEntry] is classified as
  /// archived or not.
  bool get isArchived {
    DateTime competitionDate = DateTime.tryParse(_irishFormatDate);

    /// If we failed to parse the date, set [hoursFromNow] to 0
    /// and [inPast] to true. This moves the competition to current. (we cant
    /// figure out if it is in the past or not).
    int hoursFromNow = competitionDate?.difference(DateTime.now())?.inHours?.abs() ?? 0;
    bool inPast = competitionDate?.isBefore(DateTime.now()) ?? true;

    return hoursFromNow >= 25 && inPast;
  }

  bool get longOppositionName => opposition.trim().length >= 28;

  /// Converts the date format from irish date format (dd-MM-yyyy HH:mm)
  /// to the standard DateTime format (yyyy-MM-dd HH:mm).
  String get _irishFormatDate {
    List<String> _splitDMY = date.split("-");
    return "${_splitDMY[2]}-${_splitDMY[1]}-${_splitDMY[0]} $time";
  }

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
        holes = List<Hole>.generate(
            map[Fields.holes].length, (int index) => Hole.fromMap(map[Fields.holes][index])),
        score = Score.fromMap(map[Fields.score]);

  /// Converts a database entry into a map so it can be put into the database.
  Map<String, dynamic> get toJson => {
        Fields.date: date,
        Fields.id: id,
        Fields.location: location.toJson,
        Fields.time: time,
        Fields.opposition: opposition,
        Fields.title: title,
        Fields.holes: List<Map>.generate(holes.length, (int index) => holes[index].toJson),
        Fields.score: score.toJson
      };

  /// Get a single string which contains all the data specific to this event, making
  /// it easily searchable.
  @override
  String toString() => "$date $location $time $opposition $title $holes $score";

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) =>
      other is DatabaseEntry &&
      other.id == id &&
      other.date == date &&
      other.location == location &&
      other.time == time &&
      other.opposition == opposition &&
      other.title == title &&
      other.holes == holes &&
      other.score == score;

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

/// Represents the score of either a hole or a competition.
///
/// [howth] howths current score.
///
/// [opposition] the opposing teams score.
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
  static Score get holeExample => Score(howth: "2", opposition: "1");
  static Score get empty => Score(
        howth: "0",
        opposition: "0",
      );

  static Score get fresh => Score(howth: "0", opposition: "0");

  /// Calculates the overall score of the [parsedHoles].
  ///
  /// Returns [howth] score at the 0th index, and
  /// [opposition] score at the 1st index.
  static List<String> _calculateScore(List<Hole> parsedHoles) {
    double parsedHowth = 0;
    double parsedOpposition = 0;
    for (Hole hole in parsedHoles) {
      if (hole.holeScore.howth == hole.holeScore.opposition && hole.holeScore.howth == "0") {
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

  /// Get which team is ahead!
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
        opposition: !isHowth ? (parsedOpposition + value).toString() : opposition);

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

/// Represents a match-up / hole in a competition.
///
/// Note:
///
/// In the database, [holeNumber] is actually 'hole_number',
///                  [holeScore] is actually 'hole_score' and
///                  [lastUpdated] is actually 'last_updated'. (stored as string)
///
/// [holeNumber] the current hole number for this matchup.
///
/// [holeScore] the current score for this matchup.
///
/// [players] howth player names.
///
/// [opposition] optional opposing player names.
/// If empty, the [DatabaseEntry.opposition] is used.
///
/// [comment] optional.
class Hole {
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
        players = List<String>.generate(
            map[Fields.players].length, (int index) => map[Fields.players][index].toString()),
        opposition = List<String>.generate(
            map[Fields.opposition].length, (int index) => map[Fields.opposition][index].toString()),
        comment = map[Fields.comment],
        lastUpdated = DateTime.tryParse(map[Fields.lastUpdated]);

  static Hole get example => Hole(
      holeNumber: 3,
      holeScore: Score.holeExample,
      players: ["Howth player(s)"],
      opposition: ["Opposing club/player(s)"],
      comment: Strings.empty,
      lastUpdated: DateTime.now().subtract(const Duration(seconds: 60)));

  static Hole get fresh => Hole(
      holeNumber: 0,
      holeScore: Score.fresh,
      players: [Strings.empty],
      opposition: [Strings.empty],
      comment: Strings.empty,
      lastUpdated: DateTime.now());

  static Hole get empty => Hole(
      holeNumber: 0,
      holeScore: Score.fresh,
      players: [" "],
      opposition: [" "],
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

  /// Update a hole, atleast one property must not be null.
  Hole updateHole({
    Score newScore,
    int newHoleNumber,
    List<String> newPlayers,
    List<String> newOpposition,
    String newComment,
  }) {
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
      lastUpdated: DateTime.now(),
    );
  }

  /// Turn a list of players, [playerList], into one string with
  /// those individual player names separated by commas, apart from the last
  /// player in the list.
  String _formattedNames(List<String> names) => names.fold(names.first,
      (String first, String second) => second == names.first ? first : first + ", " + second);

  /// Returns the hole players formatted, if no players are given,
  /// returns 'Howth Golf Club'.
  String get formattedPlayers =>
      _formattedNames(players).isEmpty ? Strings.homeAddress : _formattedNames(players);

  /// Returns the opposing teams players for this hole formatted.
  /// If no names are given, returns the opposing club name.
  String formattedOpposition(String oppositionClub) =>
      _formattedNames(opposition).isEmpty ? oppositionClub : _formattedNames(opposition);

  /// Convert [lastUpdated] to a pretty string.
  String get prettyLastUpdated {
    Duration difference = DateTime.now().difference(lastUpdated);

    String value;
    int displayValue;

    if (difference.inHours < 1) {
      displayValue = difference.inMinutes;

      /// Less than an hour; return in minutes.
      value = "$displayValue minute" + (displayValue == 1 ? "" : "s");
    } else if (difference.inDays < 1) {
      displayValue = difference.inHours;

      /// Less than a day; return in hours.
      value = "$displayValue hour" + (displayValue == 1 ? "" : "s");
    } else if (difference.inDays < 365) {
      displayValue = difference.inDays;

      /// Less than a year; return in days.
      value = "$displayValue day" + (displayValue == 1 ? "" : "s");
    } else {
      displayValue = difference.inDays ~/ 365;

      /// Greater than a year; return in years.
      value = "$displayValue year" + (displayValue == 1 ? "" : "s");
    }

    return "Last updated: " +
        (displayValue == 0 && value.contains("minutes") ? "just now" : "$value ago");
  }

  @override
  int get hashCode => lastUpdated.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Hole && other.lastUpdated.isAtSameMomentAs(lastUpdated);

  Hole({
    @required this.holeNumber,
    @required this.holeScore,
    @required this.players,
    this.comment,
    this.opposition,
    @required this.lastUpdated,
  });
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
  static Location get empty => Location(address: Strings.empty);

  @override
  int get hashCode => address.hashCode;

  @override
  bool operator ==(Object other) => other is Location && other.address == address;

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
        steps = List<HelpStep>.generate(
            map[Fields.steps].length, (int index) => HelpStep.fromMap(map[Fields.steps][index]));

  AppHelpEntry({@required this.title, @required this.subtitle, @required this.steps});
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
