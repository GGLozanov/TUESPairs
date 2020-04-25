import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/screens/login/login.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/services/database.dart';

// wrapper widget for authentication purposes (whether to show Register or Login widget)

class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> { // state

  bool isLoginView = true;
  void toggleView() {
    Register.currentPage = Register.topPageIndex;
    setState(() => isLoginView = !isLoginView); // setState() method reruns the build method and the function it's been given
    logger.i('Authenticate: Switched to ' + (isLoginView ? 'Login' : 'Register') + ' screen.');
  }

  final Database database = new Database();

  @override
  Widget build(BuildContext context) {

    final tags = database.tags;

    return isLoginView ? Login(toggleView: toggleView) : MultiProvider(
      providers: [
        StreamProvider<List<User>>.value(
          value: database.users,
         ),
         StreamProvider<List<Tag>>.value(
           value: tags,
         ),
        ],
       child: Register(toggleView: toggleView),
    );
    // give the toggleView function to the Register and Login widgets for usage in their own contexts
  }
}
