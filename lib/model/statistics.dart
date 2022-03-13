import 'package:repiton/model/lesson.dart';

class FinancialStatistics {
  late int allLessons;
  late double allPrice;
  late List<StudentFinancialStatistics> students;

  FinancialStatistics({
    required this.allLessons,
    required this.allPrice,
    required this.students,
  });

  FinancialStatistics.empty() {
    allLessons = 0;
    allPrice = 0;
    students = [];
  }
}

class StudentFinancialStatistics {
  late String studentId;
  late String studentName;
  late String studentLastName;
  late String studentImageUrl;
  late int presents;
  late double price;
  late List<Lesson> lessons;

  StudentFinancialStatistics({
    required this.studentId,
    required this.studentName,
    required this.studentLastName,
    required this.studentImageUrl,
    required this.presents,
    required this.price,
    required this.lessons,
  });

  StudentFinancialStatistics.empty() {
    studentId = "";
    studentName = "";
    studentLastName = "";
    studentImageUrl = "";
    presents = 0;
    price = 0;
    lessons = [];
  }
}

class LearnStatistics {
  late int allPresents;
  late int allHomeTasks;
  late List<StudentLearnStatistics> disciplines;

  LearnStatistics({
    required this.allHomeTasks,
    required this.allPresents,
    required this.disciplines,
  });

  LearnStatistics.empty() {
    allHomeTasks = 0;
    allPresents = 0;
    disciplines = [];
  }

  int get countAllLessons {
    int result = 0;
    for (StudentLearnStatistics studentLearnStatistics in disciplines) {
      result += studentLearnStatistics.lessons.length;
    }
    return result;
  }
}

class StudentLearnStatistics {
  late String teacherId;
  late String teacherName;
  late String teacherFatherName;
  late String teacherLastName;
  late String disciplineId;
  late String disciplineName;
  late String teacherImageUrl;
  late int presents;
  late int homeTasks;
  late List<Lesson> lessons;

  StudentLearnStatistics({
    required this.teacherId,
    required this.teacherName,
    required this.teacherFatherName,
    required this.teacherLastName,
    required this.teacherImageUrl,
    required this.disciplineId,
    required this.disciplineName,
    required this.presents,
    required this.homeTasks,
    required this.lessons,
  });

  StudentLearnStatistics.empty() {
    teacherId = "";
    teacherName = "";
    teacherFatherName = "";
    teacherLastName = "";
    teacherImageUrl = "";
    disciplineId = "";
    disciplineName = "";
    presents = 0;
    homeTasks = 0;
    lessons = [];
  }
}
