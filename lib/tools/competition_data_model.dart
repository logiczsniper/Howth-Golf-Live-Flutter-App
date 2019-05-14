import 'dart:convert';

class Competition {
  final int id;
  final String title;
  final String location;
  final String opposition;
  final String time;
  final String date;
  final String holes;
  final String score;

  Competition(
      {this.id,
      this.location,
      this.opposition,
      this.time,
      this.date,
      this.holes,
      this.score,
      this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'location': location,
      'opposition': opposition,
      'time': time,
      'holes': holes,
      'score': json.decode(score)
    };
  }

  @override
  String toString() {
    return 'Competition{id: $id, title: $title, date: $date, location: $location, opposition: $opposition, time: $time, holes: $holes, score: $score}';
  }
}
