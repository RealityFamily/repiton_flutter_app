import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/lessons.dart';
import 'package:repiton/widgets/jitsy_action_button.dart';

class JitsyCallScreen extends StatefulWidget {
  final String disciplineName;
  final String studentName;
  final String studentImageUrl;
  final String teacherImageUrl;

  const JitsyCallScreen({
    required this.disciplineName,
    required this.studentName,
    required this.studentImageUrl,
    required this.teacherImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<JitsyCallScreen> createState() => _JitsyCallScreenState();
}

class _JitsyCallScreenState extends State<JitsyCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onSelected: (value) {},
                    // TODO: Add items to popup menu
                    itemBuilder: (_) => []
                        .map(
                          (item) => PopupMenuItem<String>(
                            value: item,
                            child: Container(),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Consumer<Lessons>(
                    builder: (context, lessons, _) => RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: lessons.lesson!.name,
                            style: const TextStyle(fontSize: 34),
                          ),
                          TextSpan(
                            text: "\n${widget.disciplineName}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 37,
                        backgroundColor: const Color(0xFFC4C4C4),
                        child: ClipOval(
                          child: FadeInImage(
                            image: NetworkImage(widget.teacherImageUrl),
                            placeholder: const AssetImage("assets/images/user_grey.png"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      CircleAvatar(
                        radius: 37,
                        backgroundColor: const Color(0xFFC4C4C4),
                        child: ClipOval(
                          child: FadeInImage(
                            image: NetworkImage(widget.studentImageUrl),
                            placeholder: const AssetImage("assets/images/user_grey.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Текущий звонок\n"),
                        // TODO: Set jitsy call lenght
                        TextSpan(text: "00:00:01"),
                      ],
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB4B4B4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 45,
                right: 45,
                top: 25,
                bottom: 25 + MediaQuery.of(context).padding.bottom,
              ),
              color: const Color(0xFF141414),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  JitsyActionButton(
                    icon: Icons.videocam_outlined,
                    iconAlt: Icons.videocam_off_outlined,
                    onPressed: () {},
                  ),
                  JitsyActionButton(
                    icon: Icons.volume_up,
                    iconAlt: Icons.volume_off,
                    onPressed: () {},
                    initState: true,
                  ),
                  JitsyActionButton(
                    icon: Icons.stay_current_portrait,
                    iconAlt: Icons.phonelink_erase,
                    onPressed: () {},
                  ),
                  JitsyActionButton(
                    icon: Icons.mic,
                    iconAlt: Icons.mic_off,
                    onPressed: () {},
                    initState: true,
                  ),
                  JitsyActionButton(
                    icon: Icons.call_end,
                    background: Color(0xFFDE9898),
                    onPressed: () {},
                    stateful: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
