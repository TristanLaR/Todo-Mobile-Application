import 'package:todo/models/list_todo_model.dart';
import 'package:todo/models/todo_category.dart';

class Todo {
  late String id;
  late String description;
  late TodoCategory? category;
  late bool isCompleted;
  late bool isFavourite;

  Todo({
    required this.id,
    this.description = "",
    this.category,
    ListOfTodoModel? subtasks,
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

  Todo copyWith({
    String? id,
    String? description,
    TodoCategory? category,
    bool? isCompleted,
    bool? isFavourite,
  }) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Todo &&
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
