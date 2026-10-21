enum AssesmentType {quiz, midterm, finalExam}
class Result{
  final String id;
  final String studentId;
  final AssesmentType assesmentType;
  final int score;

  Result({required this.id,required this.studentId, required this.score, required this.assesmentType});
}