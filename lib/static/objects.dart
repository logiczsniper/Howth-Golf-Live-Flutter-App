class DataBaseEntry {
  final String date;
  final int id;
  final String location;
  final String time;
  final String opposition;
  final String title;
  final List<Hole> holes;
  final Map<String, String> score;

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

class Hole {
  final int holeNumber;
  final String holeScore;
  final List<String> players;
  Hole({this.holeNumber, this.holeScore, this.players});
}

class AppHelpEntry {
  final String title;
  final String subtitle;
  final List<Step> steps;
  AppHelpEntry({this.title, this.subtitle, this.steps});
}

class Step {
  final String title;
  final String data;
  Step({this.title, this.data});
}
