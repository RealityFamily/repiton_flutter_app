import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/student.dart';

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
  late Student student;
  late int presents;
  late double price;
  late List<Lesson> lessons;

  StudentFinancialStatistics({
    required this.student,
    required this.presents,
    required this.price,
    required this.lessons,
  });

  StudentFinancialStatistics.empty() {
    student = Student.empty();
    presents = 0;
    price = 0;
    lessons = [];
  }
}

class LearnStatistics {
  late int allPresents;
  late int allHomeTasks;
  late List<DisciplineLearnStatistics> disciplines;

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
    for (DisciplineLearnStatistics studentLearnStatistics in disciplines) {
      result += studentLearnStatistics.discipline.lessons.length;
    }
    return result;
  }
}

class DisciplineLearnStatistics {
  late Discipline discipline;
  late int presents;
  late int homeTasks;

  DisciplineLearnStatistics({
    required this.discipline,
    required this.presents,
    required this.homeTasks,
  });

  DisciplineLearnStatistics.empty() {
    discipline = Discipline.empty();
    presents = 0;
    homeTasks = 0;
  }
}
