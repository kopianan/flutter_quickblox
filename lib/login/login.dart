import 'package:flutter/material.dart';
import 'package:quickblox_app/home/home.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void _loginToQuickBlox() async {
    QBUser qbUser;
    QBSession qbSession;
    try {
      QBLoginResult result = await QB.auth.login("alfred", "123456789");
      qbUser = result.qbUser;
      qbSession = result.qbSession;
      print(qbSession.tokenExpirationDate);
      print(qbUser.fullName);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    qbSession: qbSession,
                    qbUser: qbUser,
                  )));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Login"),
          onPressed: () async {
            _loginToQuickBlox();
          },
        ),
      ),
    );
  }
}
