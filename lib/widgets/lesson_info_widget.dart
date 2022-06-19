import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/core/network/jitsy/jitsy_logic.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/provider/lessons.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/web_jitsi_call_screen.dart';

class LessonInfoWidget extends StatefulWidget {
  final String disciplineName;
  final String studentName;
  final String studentImageUrl;
  final String teacherImageUrl;

  const LessonInfoWidget({
    required this.disciplineName,
    required this.studentName,
    required this.studentImageUrl,
    required this.teacherImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<LessonInfoWidget> createState() => _LessonInfoWidgetState();
}

class _LessonInfoWidgetState extends State<LessonInfoWidget> {
  bool _isLoading = false;

  void _onLessonButtonTap(LessonsProvider lessons) async {
    if (lessons.lesson!.status == LessonStatus.started) {
      if (kIsWeb) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WebJitsiCallScreen()));
      } else {
        JitsyLogic.joinMeeting("Leonis", "Leonis13579", lessons.lesson!.id);
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      await lessons.startLesson();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget get _lessonButton => Consumer(
        builder: (context, ref, _) {
          final lessons = ref.watch(RootProvider.getLessonsProvider());

          return _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: kIsWeb ? const EdgeInsets.symmetric(vertical: 16, horizontal: 24) : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () => _onLessonButtonTap(lessons),
                  child: Text(
                    lessons.lesson!.status == LessonStatus.started ? "Подключиться к занятию" : "Начать занятие",
                    style: const TextStyle(fontSize: 18),
                  ),
                );
        },
      );

  Widget get _editDialog {
    String? result;
    GlobalKey<FormState> _formKey = GlobalKey();
    return AlertDialog(
      title: const Text("Введите описание к уроку"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) => value == null || value.isEmpty ? "Введите описание урока!" : null,
          onSaved: (_newValue) => result = _newValue,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(labelText: "Описание урока..."),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("ОТМЕНА")),
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState!.save();
            Navigator.of(context).pop(result);
          },
          child: const Text("ОК"),
        ),
      ],
    );
  }

  Widget get _editDescriptionButton => IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          String? _newDescription = await showDialog<String>(
            context: context,
            builder: (context) => _editDialog,
          );

          if (_newDescription == null) return;
          setState(() {
            RootProvider.getLessons().lesson!.description = _newDescription;
          });
        },
      );

  Widget get _lessonDescriptionContent {
    if (kIsWeb) {
      if (MediaQuery.of(context).size.width < 600) {
        return _tinyDescriptionContent;
      } else {
        return _wideDescriptionContent;
      }
    } else {
      return _tinyDescriptionContent;
    }
  }

  Widget get _wideDescriptionContent => Expanded(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 50),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFB4B4B4)), borderRadius: BorderRadius.circular(20)),
          child: _innerDescriptionContent,
        ),
      );

  Widget get _tinyDescriptionContent => Expanded(
        child: Column(
          children: [
            const Divider(color: Color(0xFFB4B4B4), thickness: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SizedBox(width: double.infinity, child: _innerDescriptionContent),
              ),
            ),
            const Divider(color: Color(0xFFB4B4B4), thickness: 1),
          ],
        ),
      );

  Widget get _innerDescriptionContent => Consumer(
        builder: (context, ref, _) {
          final lessons = ref.watch(RootProvider.getLessonsProvider());

          return SingleChildScrollView(
            child: Text(lessons.lesson!.description, style: const TextStyle(fontSize: 18), maxLines: null),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text("Описание", style: TextStyle(fontSize: 24)),
              ),
              _editDescriptionButton,
            ],
          ),
        ),
        _lessonDescriptionContent,
        const SizedBox(height: 20),
        _lessonButton,
        const SizedBox(height: 20),
      ],
    );
  }
}
