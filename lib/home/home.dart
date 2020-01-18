import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_app/custom_qb_user.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class Home extends StatefulWidget {
  Home({Key key, this.qbUser, this.qbSession}) : super(key: key);

  final QBUser qbUser;
  final QBSession qbSession;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  static const CHANNEL_NAME = "FlutterQBUsersChannel";
  static const _usersModule = const MethodChannel(CHANNEL_NAME);
  Future<CustomQBUser> getUsers() async {
    Map<String, Object> data = new Map();

    Map<dynamic, dynamic> list = await _usersModule.invokeMethod("getUsers", data);

    var jsonData = json.decode(json.encode(list));

    CustomQBUser userData = CustomQBUser.fromJson(jsonData);
    print(userData);
    return userData;
  }

  Future<List<Users>> _getAllUserById() async {
    List<Users> userList;
    try {
      CustomQBUser data = await getUsers();
      userList = data.users;
      return userList;
    } on PlatformException catch (e) {
      print("error");
    }
  }

  _connectToChat(QBUser user) async {
    try {
      await QB.chat.connect(user.id, "123456789");
    } catch (e) {
      print("error");
      print(e);
    }
  }

  _checkIsConnected() async {
    try {
      bool connected = await QB.chat.isConnected();
      print("connected" + connected.toString());
    } catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  _createChatOneByOne() async {
    try {
      QBDialog createdDialog = await QB.chat.createDialog([102292446, 102292683], "Private Chat", dialogType: QBChatDialogTypes.CHAT);

      print(createdDialog.name);
      print(createdDialog.roomJid);
      print(createdDialog.customData);
      print(createdDialog.id);
    } catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  _sendChat() async {
    try {
      await QB.chat.sendMessage("5e230664a0eb475c2fe01762", body: "Test pesan dong", markable: false, saveToHistory: true);
    } catch (e) {
      print("send caht");
      print(e.toString());
    }
  }

  _getHistory() async {
    try {
      List<QBMessage> messages = await QB.chat.getDialogMessages("5e230664a0eb475c2fe01762", markAsRead: true);

      // print(messages.first.id);
    } catch (e) {
      print("gethistory");
      print(e.toString());
      // Some error occured, look at the exception message for more details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.qbUser.login),
      ),
      body: Column(
        children: <Widget>[
          Text("Your token : ${widget.qbSession.token}"),
          Text("User Lists"),
          RaisedButton(
            child: Text("Connect to chat"),
            onPressed: () {
              _connectToChat(widget.qbUser);
            },
          ),
          RaisedButton(
            child: Text("Check is connected"),
            onPressed: () {
              _checkIsConnected();
            },
          ),
          RaisedButton(
            child: Text("Create chat"),
            onPressed: () {
              _createChatOneByOne();
            },
          ),
          RaisedButton(
            child: Text("Send chat"),
            onPressed: () {
              _sendChat();
            },
          ),
          RaisedButton(
            child: Text("get history chat"),
            onPressed: () {
              _getHistory();
            },
          ),
          RaisedButton(
            child: Text("get all user"),
            onPressed: () {
              _getAllUserById();
            },
          ),
          Expanded(
            child: FutureBuilder<List<Users>>(
              future: _getAllUserById(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index].fullName),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
