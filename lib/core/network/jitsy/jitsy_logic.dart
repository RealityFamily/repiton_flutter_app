import 'package:flutter/widgets.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';

class JitsyLogic {
  static void joinMeeting(String userName, String login, String room, BuildContext context) async {
    try {
      Map<FeatureFlagEnum, bool> featureFlag = {};
      featureFlag[FeatureFlagEnum.WELCOME_PAGE_ENABLED] = false;

      var options = JitsiMeetingOptions(room: room) // room is Required, spaces will be trimmed
        ..serverURL = "https://jitsi.repiton.dev.realityfamily.ru"
        ..userDisplayName = userName
        ..userEmail = login
        ..userAvatarURL = "https://someimageurl.com/image.jpg" // or .png
        ..featureFlags = featureFlag
        ..webOptions = {
          "roomName": room,
          "width": "100%",
          "height": "100%",
          "enableWelcomePage": false,
          "chromeExtensionBanner": null,
          "userInfo": {
            "displayName": userName,
            "login": login,
          },
        };

      var isLessonOn = true;

      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(
          onConferenceTerminated: (_) {
            if (isLessonOn) {
              isLessonOn = false;
              if (RootProvider.getAuth().userRole == AuthProvider.teacherRole) RootProvider.getLessons().endLesson();
              Navigator.of(context).pop();
            }
          },
        ),
      );
    } catch (error, stackTrace) {
      debugPrint("error: $error \n $stackTrace");
    }
  }
}
