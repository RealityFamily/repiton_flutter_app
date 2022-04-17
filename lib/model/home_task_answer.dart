import 'package:repiton/model/home_task_mark.dart';
import 'package:repiton/model/remote_file.dart';

class HomeTaskAnswer {
  String? id;
  late String answer;
  String? comment;
  late List<RemoteFile> files;
  HomeTaskMark? homeTaskMark;

  HomeTaskAnswer({
    this.id,
    required this.answer,
    this.comment,
    required this.files,
    this.homeTaskMark,
  });
}
