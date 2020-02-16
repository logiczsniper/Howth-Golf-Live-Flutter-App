import 'package:howth_golf_live/services/models.dart';

class HelpData {
  /// The actual instructions for each of the guides in app help.
  static final List<Map<String, dynamic>> _data = [
    {
      'title': 'Gaining Admin Privileges',
      'subtitle': 'Highest level permissions',
      'steps': [
        {
          'title': 'Go to the app help page',
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
          'title': 'Go to the competitions page',
          'data':
              'Click the home icon in the top right corner of this page to return to the Competitions page.'
        },
        {
          'title': 'Locate your competition',
          'data':
              'Scroll through the current & archived competitions to find your competition.'
        },
        {
          'title': 'Click on the competition',
          'data':
              'Tap anywhere on it\'s card to enter page with the details of your competition.'
        },
        {
          'title': 'Show the text field',
          'data':
              'Click the admin icon in the top right corner of the page. A text field should appear.'
        },
        {
          'title': 'Enter your code',
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
          'title': 'Competition details',
          'data':
              'At the top middle of a specific competition page: opposition, location & lastly the time.'
        },
        {
          'title': 'Searching for a competition',
          'data':
              'In the Competitions page, hit the magnifying glass icon in the top right & enter search text.'
        },
      ]
    },

    /// Team manager & admin entries.
    {
      'title': 'Updating Scores',
      'subtitle': 'For admins & team managers.',
      'steps': [
        {
          'title': 'Add/Remove a hole',
          'data': 'Adding/Removing a hole will update the competition score!'
        },
        {
          'title': 'Add a hole part 1',
          'data':
              'Click on the \'Add a Hole\' button at the bottom of the hole.'
        },
        {
          'title': 'Add a hole part 2',
          'data': 'Fill out the form and press the check icon in the top right.'
        },
        {
          'title': 'Remove a hole',
          'data':
              'In the competition, click the remove icon to the right of the hole to be removed.'
        },
      ]
    },

    /// Admin entries.
    {
      'title': 'Updating Competitions',
      'subtitle': 'For admins only.',
      'steps': [
        {
          'title': 'Add a competition part 1',
          'data':
              'Click on the \'Add a Competition\' button at the bottom of competitions.'
        },
        {
          'title': 'Add a competition part 2',
          'data': 'Fill out the form and press the check icon in the top right.'
        },
        {
          'title': 'Remove a competition',
          'data':
              'In competitions, click the remove icon to the right of the competition to be removed.'
        },
      ]
    }
  ];

  static List<AppHelpEntry> get entries =>
      _data.map((Map data) => AppHelpEntry.fromMap(data)).toList();
}
