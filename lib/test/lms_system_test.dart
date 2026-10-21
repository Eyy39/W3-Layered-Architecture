// import 'package:lms_layered_architecture_example/model/course.dart';
import 'package:lms_layered_architecture_example/model/result.dart';
import 'package:test/test.dart';

import '../service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });


  test('create course: ', (){
    // create course
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile');
    expect(lms.courses.first.name, 'Mobile');
  });


  // Task 1 — Add and remove courses
  test('create and removes a course', () {
    final lms = LmsSystem();

    lms.addCourse(
      courseId: 'C1',
      courseName: 'Mobile Development',
    );

    lms.removeCourse(courseId: 'C1');
    expect(lms.courses, isEmpty);
  });
  
  test('rejects duplicate course ID', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(
      () => lms.addCourse(
        courseId: 'C1',
        courseName: 'Another Course',
      ),
      throwsException,
    );
  });

  test('rejects removal of nonexistent course', () {
    final lms = LmsSystem();
    expect(
      () => lms.removeCourse(courseId: 'C99'),
      throwsException,
    );
  });

// Task 2 — Enroll a student in a course
  test('records enrollment student', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);

    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(lms.courses.single.studentIds, contains('S1'));
    expect(lms.courses.single.studentIds, hasLength(1));
  });

  test('rejects enrollment when the student does not exist', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);

    expect(
      () => lms.enrollStudent(studentId: 'S99', courseId: 'C1'),
      throwsException,
    );
  });

  test('rejects enrollment when the course does not exist', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');

    expect(
      () => lms.enrollStudent(studentId: 'S1', courseId: 'C99'),
      throwsException,
    );
  });

  test('rejects duplicate enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 2);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(
      () => lms.enrollStudent(studentId: 'S1', courseId: 'C1'),
      throwsException,
    );
  });

// Task 3 — Remove a student from a course
  test('removes an existing enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(lms.discardStudentFromCourse('S1', 'C1'), isTrue);
    expect(lms.courses.single.studentIds, isEmpty);
  });

  test('rejects removal of a nonexistent enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);

    expect(
      () => lms.discardStudentFromCourse('S1', 'C1'),
      throwsException,
    );
  });

  test('keeps the student and course after removing an enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    lms.discardStudentFromCourse('S1', 'C1');

    expect(lms.students.single.id, 'S1');
    expect(lms.courses.single.id, 'C1');
  });

  test('removing an enrollment also removes its results', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.addResult('S1', 'C1', AssesmentType.quiz, 90);

    lms.discardStudentFromCourse('S1', 'C1');

    expect(lms.courses.single.results, isEmpty);
    expect(lms.courses.single.scoreIds, isEmpty);
  });

  test('removing a student removes enrollments from all courses', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);
    lms.addCourse(courseId: 'C2', courseName: 'Data Structures', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S1', courseId: 'C2');

    lms.removeStudent(studentId: 'S1');

    expect(lms.students, isEmpty);
    expect(lms.courses.every((course) => course.studentIds.isEmpty), isTrue);
  });

// Task 4 — Add a result to a course
  test('adds a valid result', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    lms.addResult('S1', 'C1', AssesmentType.quiz, 90);

    final result = lms.courses.single.results.single;
    expect(result.studentId, 'S1');
    expect(result.assesmentType, AssesmentType.quiz);
    expect(result.score, 90);
  });

  test('rejects a result for a nonexistent course', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');

    expect(
      () => lms.addResult('S1', 'C99', AssesmentType.quiz, 90),
      throwsException,
    );
  });

  test('rejects a result for a student who is not enrolled', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);

    expect(
      () => lms.addResult('S1', 'C1', AssesmentType.quiz, 90),
      throwsException,
    );
  });

  test('rejects invalid score', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(
      () => lms.addResult('S1', 'C1', AssesmentType.quiz, -1),
      throwsException,
    );
    expect(
      () => lms.addResult('S1', 'C1', AssesmentType.quiz, 101),
      throwsException,
    );
  });

  test('rejects duplicate results for the same assessment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.addResult('S1', 'C1', AssesmentType.quiz, 90);

    expect(
      () => lms.addResult('S1', 'C1', AssesmentType.quiz, 95),
      throwsException,
    );
  });

  test('chosen dublicate policy', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.addResult('S1', 'C1', AssesmentType.quiz, 90);

    lms.addResult('S1', 'C1', AssesmentType.midterm, 85);

    expect(lms.courses.single.results, hasLength(2));
  });

// Task 5 — Remove a student result
  test('removes an existing result', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 2);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.addResult('S1', 'C1', AssesmentType.quiz, 90);

    lms.removeResult('S1');

    expect(lms.courses.single.results, isEmpty);
  });

  test('rejects removal of a nonexistent result', () {
    final lms = LmsSystem();

    expect(
      () => lms.removeResult('R99'),
      throwsException,
    );
  });

  test('removing a result preserves its student, course, and unrelated results', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'Ronan');
    lms.addStudent(studentId: 'S2', studentName: 'Mony');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development', capacity: 2);
    lms.addCourse(courseId: 'C2', courseName: 'Data Structures', capacity: 1);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');
    lms.enrollStudent(studentId: 'S1', courseId: 'C2');
    lms.addResult('S1', 'C1', AssesmentType.quiz, 90);
    lms.addResult('S2', 'C1', AssesmentType.quiz, 80);
    lms.addResult('S1', 'C2', AssesmentType.quiz, 70);

    lms.removeResult('S1');

    expect(lms.students.map((student) => student.id), containsAll(['S1', 'S2']));
    expect(lms.courses.map((course) => course.id), containsAll(['C1', 'C2']));
    expect(lms.courses[0].results.single.studentId, 'S2');
    expect(lms.courses[0].results.single.score, 80);
    expect(lms.courses[1].results.single.studentId, 'S1');
    expect(lms.courses[1].results.single.score, 70);
  });

 }
