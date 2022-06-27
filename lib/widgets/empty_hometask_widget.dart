import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/teacher/create_hometask_screen.dart';
import 'package:repiton/utils/device_size.dart';

class EmptyHometaskWidget extends StatelessWidget {
  const EmptyHometaskWidget({Key? key}) : super(key: key);

  Widget get _createHomeTaskButton => Consumer(
        builder: (context, ref, _) {
          final lessons = ref.watch(RootProvider.getLessonsProvider());

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: kIsWeb ? const EdgeInsets.symmetric(vertical: 16, horizontal: 24) : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            onPressed: () async {
              HomeTask? _newHometask = await Navigator.of(context).push<HomeTask>(MaterialPageRoute(builder: (context) => const CreateHometaskScreen()));

              if (_newHometask == null) return;
              lessons.setHometask(_newHometask);
            },
            child: const Text("Создать домашнее задание", style: TextStyle(fontSize: 18)),
          );
        },
      );

  Widget _emptyHomeTaskContent(BuildContext context) {
    if (kIsWeb) {
      if (DeviceSize.isTinyScreen(context)) {
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
            Expanded(child: _innerDescriptionContent),
            const Divider(color: Color(0xFFB4B4B4), thickness: 1),
          ],
        ),
      );

  Widget get _innerDescriptionContent => Center(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Домашнее задание пока не задано", style: TextStyle(fontSize: 18)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        _emptyHomeTaskContent(context),
        const SizedBox(height: 20),
        _createHomeTaskButton,
        const SizedBox(height: 20),
      ],
    );
  }
}
