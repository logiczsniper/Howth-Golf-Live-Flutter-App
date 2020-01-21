class HelpData {
  /// The actual instructions for each of the guides in app help.
  static final List<Map<String, dynamic>> _entryData = [
    {
      'title': 'Gaining Admin Privileges',
      'subtitle': 'Highest level permissions',
      'steps': [
        {
          'title': 'Return to the app help page',
          'data':
              'Click the arrow icon in the top left corner of this page to go back to the App Help page.'
        },
        {
          'title': 'Show the text field',
          'data':
              'Click the admin icon in the top right corner of the page. A text field should appear.'
        },
        {
          'title': 'Enter your admin code',
          'data':
              'Click on the text field that has appeared & type in your admin code.'
        },
        {
          'title': 'Submit entered code',
          'data':
              'Click the admin icon in the top right corner of the page. The text field vanishes.'
        },
      ]
    },
    {
      'title': 'Competition Score Access',
      'subtitle': 'Low level permissions',
      'steps': [
        {
          'title': 'Return to the competitions page',
          'data':
              'Click the home icon in the top right corner of this page to return to the Competitions page.'
        },
        {
          'title': 'Locate competition to be accessed',
          'data':
              'Scroll through the current & archived competitions to find your competition.'
        },
        {
          'title': 'Click on the compeition',
          'data':
              'Tap anywhere on it\'s card to enter page with the details of your competition.'
        },
        {
          'title': 'Show the text field',
          'data':
              'Click the admin icon in the top right corner of the page. A text field should appear.'
        },
        {
          'title': 'Enter your competition code',
          'data':
              'Click on the text field that has appeared & type in your competition code.'
        },
        {
          'title': 'Submit entered code',
          'data':
              'Click the admin icon in the top right corner of the page. The text field vanishes.'
        },
      ]
    },
    {
      'title': 'General App Usage',
      'subtitle': 'Understanding Howth Golf Live',
      'steps': [
        {
          'title': 'Competition score display',
          'data':
              'At the top of each competition page, the score on the left is always Howth.'
        },
        {
          'title': 'Refresh all competitions',
          'data':
              'There is no need- the Competitions page is always up to date.'
        },
        {
          'title': 'Refresh specific competition',
          'data':
              'On a specific competition page, drag the list from top to bottom.'
        },
        {
          'title': 'Understanding competition details',
          'data':
              'At the top middle of a specific competition page: opposition, location & lastly the time.'
        },
        {
          'title': 'Searching for a competition',
          'data':
              'In the Competitions page, hit the magnifying glass icon in the top right & enter search text.'
        },
      ]
    }
  ];

  /// Converting the hidden data (above) into a useful list of AppHelpEntries. These are constant.
  static List<AppHelpEntry> entries = List<AppHelpEntry>.generate(
      _entryData.length,
      (int index) => AppHelpEntry.fromMap(_entryData[index]));
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
