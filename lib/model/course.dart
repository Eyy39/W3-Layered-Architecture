import 'result.dart';

class Course {
  final String id;
  final String name;
  final List<String> studentIds = [];
  final List<String> scoreIds = [];
  final List<Result> results = [];
  int capacity;

  Course({required this.id, required this.name, this.capacity = 0});
  
}
