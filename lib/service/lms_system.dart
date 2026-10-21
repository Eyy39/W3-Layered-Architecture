import '../model/student.dart';
import '../model/course.dart';
import '../model/result.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];

  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    for (final course in courses) {
      course.studentIds.remove(studentId);
      course.scoreIds.remove(studentId);
      course.results.removeWhere((result) => result.studentId == studentId);
    }
    students.removeWhere((student) => student.id == studentId);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  }

  void addCourse({required String courseId, required String courseName, int capacity = 0}) {
    Course? course = _findCourseOrNull(courseId);
    if (course != null) {
      throw Exception('Student $course already exists');
    }
    courses.add(Course(id: courseId, name: courseName, capacity: capacity));
  }

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }
    return null;
  }

  void removeCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    courses.removeWhere((c) => c.id == courseId);
  }

  void enrollStudent({required String studentId, required String courseId}){
    final student = _findStudentOrNull(studentId);
    if(student == null){
      throw Exception('Student $studentId not found');
    }

    final course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $course not found');
    }
    if(course.studentIds.length >= course.capacity){
      throw Exception('${courseId} is fulled!');
    }
    if(course.studentIds.contains(studentId)){
      throw Exception('Student ${studentId} already exist in this $courseId');
    }
    
    course.studentIds.add(studentId);
  }

  bool discardStudentFromCourse(String studentId, String courseId){
    final student = _findStudentOrNull(studentId);
    if(student == null){
      throw Exception('Student $studentId not found');
    }
    final course = _findCourseOrNull(courseId);
    if(course == null){
      throw Exception('Course $courseId not found');
    }
    if(!course.studentIds.contains(studentId)){
      throw Exception('Student $studentId is not enrolled in $courseId');
    }

    course.studentIds.remove(studentId);
    course.scoreIds.remove(studentId);
    course.results.removeWhere((result) => result.id == studentId);
    return true;
  }

  void addResult(String studentId, String courseId,AssesmentType assesmentType, int score) {
    if(_findStudentOrNull(studentId) == null){
      throw Exception('Student $studentId not found');
    }

    final course = _findCourseOrNull(courseId);
    if(course == null) {
      throw Exception('Course $courseId not found');
    }

    if(!course.studentIds.contains(studentId)){
      throw Exception('Student $studentId is not enrolled in $courseId');
    }

    if(score < 0 || score > 100){
      throw Exception('Score must be between 0 and 100');
    }
    
    final dublicate = course.results.any((result) => result.studentId == studentId && result.assesmentType == assesmentType);
    if(dublicate){
      throw Exception('Student $studentId already has a result for $courseId');
    }

    course.results.add(Result(id: studentId, studentId: studentId, score: score, assesmentType: assesmentType));
    course.scoreIds.add(studentId);
  }

  void removeResult(resultId){
    Course? foundCourse;
    for(final course in courses){
      if(course.results.any((result) => result.id == resultId)){
        foundCourse = course;
        break;
      };
    }
    if(foundCourse == null){
      throw Exception('Result $resultId not found');
    }

    foundCourse.results.removeWhere((result)=> result.id == resultId);
    foundCourse.scoreIds.remove(resultId);    
  }

}
