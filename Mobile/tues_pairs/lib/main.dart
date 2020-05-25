import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/screens/register/extern_register.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/services/messaging.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tues_pairs/screens/authlistener.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MessagingService.configureFirebaseListeners();

  runApp(App());
}

class App extends StatelessWidget {
  static String currentUserDeviceToken;
  final Auth _auth = new Auth();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // limit the orientation to portrait up and portrait down

    logger.i('App: App started.');

    return StreamProvider<User>.value( // StreamProvider package allows us to send data through a stream to see whether the auth state has changed here. This data can travel through the widget tree.
      value: _auth.user, // create an instance of AuthListener() and set the value of the stream listener to the user stream (and auth.onAuthStateChanged gives that)
      child: MaterialApp( // Now MaterialApp, AuthListener, and all future widgets will have access to the value in the StreamProvider (cross-widget communication!)
        key: Key(Keys.app),
        title: 'TUESPairs',
        supportedLocales: [
          Locale('en', 'US'),
          Locale('bg', 'BG'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeListResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.first.languageCode &&
                supportedLocale.countryCode == locale.first.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: FutureBuilder<String>(
          future: MessagingService.getUserDeviceToken(), // get the user's device token once and set it
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              App.currentUserDeviceToken = snapshot.data;
              return Scaffold(
                body: DoubleBackToCloseApp(
                  snackBar: SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                    backgroundColor: Colors.orange,
                    content: Text(
                      'Tap again to leave',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Nilam',
                        fontSize: 20.0,
                      ),
                    )
                  ),
                  child: AuthListener()
                ),
              );
            } else {
              return Loading();
            }
          }
        )
      )
    );
  }
}

