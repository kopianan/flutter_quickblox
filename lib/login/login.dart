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
  void _loginToQuickBlox(String login, String pass) async {
    QBUser qbUser;
    QBSession qbSession;
    try {
      QBLoginResult result = await QB.auth.login("$login", "$pass");
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

  List<LoginModel> lists = [LoginModel(login: "anan", password: "123456789"), LoginModel(login: "alfred", password: "123456789")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
        body: Center(
      child: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lists[index].login),
            onTap: () => _loginToQuickBlox(lists[index].login, lists[index].password),
          );
        },
      ),
    ));
  }
}

class LoginModel {
  final String login;
  final String password;
  LoginModel({this.login, this.password});
}
