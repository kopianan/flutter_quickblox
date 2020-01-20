import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_app/call/call.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';

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
    print(widget.qbSession.token);
  }

  void _connectToChat(QBUser qbUser) async {
    try {
      await QB.chat.connect(qbUser.id, "123456789");
      print("Berhasil connect");
    } on PlatformException catch (e) {
      print(e.message);
      print(e.code);
    }
  }

  void _createRoomChat() async {
    try {
      QBDialog createdDialog = await QB.chat.createDialog(
        [102292683, 102292446],
        "Room Test",
        dialogType: QBChatDialogTypes.PUBLIC_CHAT,
      );
      print(createdDialog.id.toString() + " ROOM ID");
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void _sendMessage(String message) async {
    try {
      await QB.chat.sendMessage("5e242028a28f9a53409f10bc", body: message, markable: false, saveToHistory: true);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<List<QBMessage>> _getHistoryChat() async {
    try {
      List<QBMessage> messages = await QB.chat.getDialogMessages("5e242028a28f9a53409f10bc", markAsRead: false);
      return messages;
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<List<QBUser>> _getUserList() async {
    try {
      List<QBUser> userList = await QB.users.getUsers();
      return userList;
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }
  Future<List<QBUser>> _subscribeToCall() async {
    
    String eventName = QBRTCEventTypes.CALL;

try {
  await QB.webrtc.subscribeRTCEventTypes(eventName, (data) {
    
  });
} on PlatformException catch (e) {
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.qbUser.fullName),
      ),
      body: Column(
        children: <Widget>[
          Text("Your token : ${widget.qbSession.token}"),
          RaisedButton(
            child: Text("Connect To CHat"),
            onPressed: () => _connectToChat(widget.qbUser),
          ),
          RaisedButton(
            child: Text("Create Room Chat"),
            onPressed: () => _createRoomChat(),
          ),
          RaisedButton(
            child: Text("Send Room Chat"),
            onPressed: () => _sendMessage("hai nama aku alfred"),
          ),
          RaisedButton(
            child: Text("Subcribe to call"),
            onPressed: () => _subscribeToCall(),
          ),
          Expanded(
            child: FutureBuilder<List<QBUser>>(
              future: _getUserList(),
              builder: (context, snpshot) {
                return ListView.builder(
                  itemCount: snpshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Call(
                                      qbUser: snpshot.data[index],
                                    )));
                      },
                      title: Text(snpshot.data[index].fullName.toString()),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
