import 'package:flutter/material.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

class Home extends StatefulWidget {
  Home({Key key, this.qbUser, this.qbSession}) : super(key: key);

  final QBUser qbUser;
  final QBSession qbSession;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.qbUser.fullName),
      ),
      body: Column(
        children: <Widget>[Text("Your token : ${widget.qbSession.token}")],
      ),
    );
  }
}
