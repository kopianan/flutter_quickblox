import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';

class Call extends StatefulWidget {
  Call({Key key, this.qbUser}) : super(key: key);
  final QBUser qbUser ; 

  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  void _initialWebRTC() async {
    try {
      await QB.webrtc.init();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    _initialWebRTC();
    super.initState();
  }

  RTCVideoViewController _localVideoViewController;
  RTCVideoViewController _remoteVideoViewController;
  void _onLocalVideoViewCreated(RTCVideoViewController controller) {
    _localVideoViewController = controller;
  }

  void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
    _remoteVideoViewController = controller;
  }

  Future<void> play() async {
    _localVideoViewController.play("6d310497-e047-472a-ad5d-5b7964a830b1", 102292683);
    _remoteVideoViewController.play("6d310497-e047-472a-ad5d-5b7964a830b1", 102292446);
  }

  _call() async {
    List<int> opponentIds = [102292683, 102292683];
    int sessionType = QBRTCSessionTypes.VIDEO;

    try {
      QBRTCSession session = await QB.webrtc.call(opponentIds, sessionType);
      print(session.id); 
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              child: new Container(
            margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            width: 160.0,
            height: 160.0,
            child: RTCVideoView(
              onVideoViewCreated: _onLocalVideoViewCreated,
            ),
            decoration: new BoxDecoration(color: Colors.black54),
          )),
          Container(
            margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            width: 160.0,
            height: 160.0,
            child: RTCVideoView(
              onVideoViewCreated: _onRemoteVideoViewCreated,
            ),
            decoration: new BoxDecoration(color: Colors.black54),
          ),
          RaisedButton(
            child: Text("Call"),
            onPressed: () {
              play();
            },
          ),
          RaisedButton(
            child: Text("Session Make"),
            onPressed: () {
              _call();
            },
          )
        ],
      ),
    );
  }
}
