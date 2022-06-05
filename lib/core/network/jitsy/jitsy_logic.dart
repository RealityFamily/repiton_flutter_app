import 'package:flutter/widgets.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class JitsyLogic {
  static void joinMeeting() async {
    try {
      Map<FeatureFlagEnum, bool> featureFlag = {};
      featureFlag[FeatureFlagEnum.WELCOME_PAGE_ENABLED] = false;

      var options =
          JitsiMeetingOptions(room: "RocketChatZ4Sdr5B2CN5kuKsHfGENERAL") // room is Required, spaces will be trimmed
            ..serverURL = "https://jitsi.repiton.dev.realityfamily.ru"
            ..subject = "Meeting with Gunschu"
            ..userDisplayName = "My Name"
            ..userEmail = "myemail@email.com"
            ..userAvatarURL = "https://someimageurl.com/image.jpg" // or .png
            ..audioOnly = true
            ..audioMuted = true
            ..videoMuted = true
            ..featureFlags = featureFlag;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }
}
