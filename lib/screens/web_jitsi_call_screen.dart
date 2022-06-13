import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:repiton/core/network/jitsy/jitsy_logic.dart';

class WebJitsiCallScreen extends StatelessWidget {
  const WebJitsiCallScreen({Key? key}) : super(key: key);

  void _connectToCall(_) {
    JitsyLogic.joinMeeting("Leonis", "Leonis13579", "123-456-789");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_connectToCall);

    return JitsiMeetConferencing(
      extraJS: [
        // extraJs setup example
        '<script>function echo(){console.log("echo!!!")};</script>',
        '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
      ],
    );
  }
}
