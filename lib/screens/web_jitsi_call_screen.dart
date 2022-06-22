import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:repiton/core/network/jitsy/jitsy_logic.dart';

class WebJitsiCallScreen extends StatelessWidget {
  final String roomId;
  final String userName;
  final String login;

  const WebJitsiCallScreen({required this.roomId, required this.userName, required this.login, Key? key}) : super(key: key);

  void _connectToCall(BuildContext context) {
    JitsyLogic.joinMeeting(userName, login, roomId, context);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _connectToCall(context));

    return JitsiMeetConferencing(
      extraJS: const [
        // extraJs setup example
        '<script>function echo(){console.log("echo!!!")};</script>',
        '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
      ],
    );
  }
}
