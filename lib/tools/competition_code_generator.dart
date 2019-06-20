import 'dart:math';

/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howth_golf_live/static/constants.dart';
import 'package:howth_golf_live/static/objects.dart'; */

class CompetitionCodeGenerator {
  final Random randomIntGenerator = Random();

/*   List<int> getUsedCodes() {
    List<int> output = [];
    Future<QuerySnapshot> newData = Firestore.instance
        .collection(Constants.competitionsText.toLowerCase())
        .snapshots()
        .first;
    newData.then((QuerySnapshot snapshot) {
      List<Map> databaseOutput =
          snapshot.documents[0].data.entries.toList()[0].value;
      List<DataBaseEntry> parsedOutput = [];
      databaseOutput.forEach((Map map) {
        parsedOutput.add(DataBaseEntry.buildFromMap(map));
      });

      for (DataBaseEntry entry in parsedOutput) {
        output.add(entry.id);
      }
    });
    return output;
  }
 */
  int generateCode() {
    String code = '';

    for (var i = 0; i < 6; i++) {
      int nextInt = randomIntGenerator.nextInt(10);
      if (nextInt == 0 && code == '') {
        i -= 1;
        continue;
      }
      code += nextInt.toString();
    }

    return int.parse(code);
  }
}
