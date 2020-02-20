import 'package:howth_golf_live/constants/fields.dart';
import 'package:howth_golf_live/domain/models.dart';

class HelpData {
  /// The actual instructions for each of the guides in app help.
  static final List<Map<String, dynamic>> _data = [
    {
      Fields.title: 'Gaining Admin Privileges',
      Fields.subtitle: 'Highest level permissions',
      Fields.steps: [
        {
          Fields.title: 'Go to the app help page',
          Fields.data:
              'Click the arrow icon in the top left corner of this page to go back to the App Help page.'
        },
        {
          Fields.title: 'Show the text field',
          Fields.data:
              'Click the admin icon in the top right corner of the page. A text field should appear.'
        },
        {
          Fields.title: 'Enter your admin code',
          Fields.data:
              'Click on the text field that has appeared & type in your admin code.'
        },
        {
          Fields.title: 'Submit entered code',
          Fields.data:
              'Click the admin icon in the top right corner of the page. The text field vanishes.'
        },
      ]
    },
    {
      Fields.title: 'Competition Score Access',
      Fields.subtitle: 'Low level permissions',
      Fields.steps: [
        {
          Fields.title: 'Go to the competitions page',
          Fields.data:
              'Click the home icon in the top right corner of this page to return to the Competitions page.'
        },
        {
          Fields.title: 'Locate your competition',
          Fields.data:
              'Scroll through the current & archived competitions to find your competition.'
        },
        {
          Fields.title: 'Click on the competition',
          Fields.data:
              'Tap anywhere on it\'s card to enter page with the details of your competition.'
        },
        {
          Fields.title: 'Show the text field',
          Fields.data:
              'Click the admin icon in the top right corner of the page. A text field should appear.'
        },
        {
          Fields.title: 'Enter your code',
          Fields.data:
              'Click on the text field that has appeared & type in your competition code.'
        },
        {
          Fields.title: 'Submit entered code',
          Fields.data:
              'Click the admin icon in the top right corner of the page. The text field vanishes.'
        },
      ]
    },
    {
      Fields.title: 'General App Usage',
      Fields.subtitle: 'Understanding Howth Golf Live',
      Fields.steps: [
        {
          Fields.title: 'Competition score display',
          Fields.data:
              'At the top of each competition page, the score on the left is always Howth.'
        },
        {
          Fields.title: 'Refresh all competitions',
          Fields.data:
              'There is no need- the Competitions page is always up to date.'
        },
        {
          Fields.title: 'Refresh specific competition',
          Fields.data:
              'On a specific competition page, drag the list from top to bottom.'
        },
        {
          Fields.title: 'Competition details',
          Fields.data:
              'At the top middle of a specific competition page: opposition, location & lastly the time.'
        },
        {
          Fields.title: 'Searching for a competition',
          Fields.data:
              'In the Competitions page, hit the magnifying glass icon in the top right & enter search text.'
        },
      ]
    },

    /// Team manager & admin entries.
    {
      Fields.title: 'Updating Scores',
      Fields.subtitle: 'For admins & team managers.',
      Fields.steps: [
        {
          Fields.title: 'Add/Remove a hole',
          Fields.data:
              'Adding/Removing a hole will update the competition score!'
        },
        {
          Fields.title: 'Add a hole part 1',
          Fields.data:
              'Click on the \'Add a Hole\' button at the bottom of the hole.'
        },
        {
          Fields.title: 'Add a hole part 2',
          Fields.data:
              'Fill out the form and press the check icon in the top right.'
        },
        {
          Fields.title: 'Remove a hole',
          Fields.data:
              'In the competition, click the remove icon to the right of the hole to be removed.'
        },
      ]
    },

    /// Admin entries.
    {
      Fields.title: 'Updating Competitions',
      Fields.subtitle: 'For admins only.',
      Fields.steps: [
        {
          Fields.title: 'Add a competition part 1',
          Fields.data:
              'Click on the \'Add a Competition\' button at the bottom of competitions.'
        },
        {
          Fields.title: 'Add a competition part 2',
          Fields.data:
              'Fill out the form and press the check icon in the top right.'
        },
        {
          Fields.title: 'Remove a competition',
          Fields.data:
              'In competitions, click the remove icon to the right of the competition to be removed.'
        },
      ]
    }
  ];

  static List<AppHelpEntry> get entries =>
      _data.map((Map data) => AppHelpEntry.fromMap(data)).toList();
}
