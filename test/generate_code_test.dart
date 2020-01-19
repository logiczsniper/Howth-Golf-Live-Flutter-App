import 'package:howth_golf_live/static/competition_code_generator.dart';
import 'package:test/test.dart';

/// flutter pub run test test\generate_code_test.dart

void main() {
  CompetitionCodeGenerator competitionCodeGenerator;
  List createdCodes;
  setUp(() {
    competitionCodeGenerator = CompetitionCodeGenerator();
    createdCodes = [];
  });
  test("generate_code() creates unique codes each time", () {
    for (var i = 0; i < 100; i++) {
      createdCodes.add(competitionCodeGenerator.generateCode());
    }
    print("Codes generated: \n$createdCodes");
    bool areCodesUnique =
        createdCodes.toSet().toList().toString() == createdCodes.toString();
    bool sixDigitCodes = true;
    for (int code in createdCodes) {
      if (code.toString().length != 6) {
        sixDigitCodes = false;
        break;
      }
    }
    expect(areCodesUnique, true);
    expect(sixDigitCodes, true);
  });
}
