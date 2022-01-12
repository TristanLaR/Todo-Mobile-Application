import 'package:todo/models/todo_category.dart';

class Todo {
  late String id;
  late String description;
  late TodoCategory category;
  late bool isCompleted;
  late bool isFavourite;

  Todo({
    required this.id,
    required this.description,
    required this.category,
    this.isCompleted = false,
    this.isFavourite = false,
  });

  Todo.fromJson(Map<String, dynamic> json) {
    id = json["id"].toString();
    description = json["description"].toString();
    isCompleted = json["isCompleted"] ?? false;
    isFavourite = json["isFavourite"] ?? false;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["description"] = description;
    data["isCompleted"] = isCompleted;
    data["isFavourite"] = isFavourite;
    return data;
  }
}
