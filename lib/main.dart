import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:howth_golf_live/app/help/help_data_view_model.dart';
import 'package:howth_golf_live/app/home/authentication_view_model.dart';
import 'package:howth_golf_live/app/hole/hole_view_model.dart';
import 'package:howth_golf_live/app/user_status_view_model.dart';
import 'package:howth_golf_live/app/firebase_view_model.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/routing/routes.dart';
import 'package:howth_golf_live/style/themes.dart';
import 'package:howth_golf_live/widgets/toolkit.dart';

void main() => runApp(MultiProvider(child: MyApp(), providers: [
      ChangeNotifierProvider<UserStatusViewModel>(
          create: (_) => UserStatusViewModel()),
      ChangeNotifierProvider<AuthenticationViewModel>(
          create: (_) => AuthenticationViewModel()),
      FutureProvider<HelpDataViewModel>(
          create: (_) => HelpDataViewModel.getModel,
          initialData: HelpDataViewModel.init()),
      StreamProvider<FirebaseViewModel>(
          create: (_) => FirebaseViewModel.stream,
          initialData: FirebaseViewModel.init()),
      ProxyProvider<FirebaseViewModel, HoleViewModel>(
        update: (_, firebaseModel, __) => HoleViewModel(firebaseModel),
      )
    ]));

class MyApp extends StatelessWidget {
  /// The root of the app.
  @override
  Widget build(BuildContext context) => MaterialApp(
      builder: UIToolkit.appBuilder,
      title: Strings.appName,
      initialRoute: Routes.home,
      routes: Routes.map,
      theme: Themes.appTheme);
}
