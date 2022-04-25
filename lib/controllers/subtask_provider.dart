import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/models/list_todo_model.dart';
import 'package:todo/models/todo_category.dart';
import 'package:todo/models/todo_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final subtaskProvider =
    StateNotifierProvider<SubtaskProvider, ListOfTodoModel>((ref) {
  return SubtaskProvider(ListOfTodoModel(data: []));
});

class SubtaskProvider extends StateNotifier<ListOfTodoModel> {
  SubtaskProvider(ListOfTodoModel initialTodos) : super(initialTodos);

  /// Adds a new [Todo] to the list
  void add(TodoCategory category) {
    Todo todo = Todo(id: _uuid.v4(), category: category);
    state = ListOfTodoModel(data: [
      ...state.data,
      todo
    ]);
  }

  /// Toggle Favourite
  void toggleFavourite(String id) async {
    state = ListOfTodoModel(data: [
      for (final todo in state.data)
        if (todo.id == id)
          Todo(
              id: todo.id,
              description: todo.description,
              category: todo.category,
              isCompleted: todo.isCompleted,
              isFavourite: !todo.isFavourite)
        else
          todo,
    ]);
  }

  /// Toggle Completed
  void toggleCompleted(String id) {
    state = ListOfTodoModel(data: [
      for (final todo in state.data)
        if (todo.id == id)
          Todo(
            id: todo.id,
            description: todo.description,
            category: todo.category,
            isCompleted: !todo.isCompleted,
            isFavourite: todo.isFavourite,
          )
        else
          todo,
    ]);
  }

  /// Edit the description of [Todo].
  void edit({required String id, required String description}) {
    state = ListOfTodoModel(data: [
      for (final todo in state.data)
        if (todo.id == id)
          Todo(
            id: todo.id,
            description: description,
            category: todo.category,
            isCompleted: todo.isCompleted,
            isFavourite: todo.isFavourite,
          )
        else
          todo,
    ]);
  }

  /// Remove [Todo] from List
  void removeTodo(Todo target) {
    state = ListOfTodoModel(
        data: state.data.where((todo) => todo.id != target.id).toList());
  }
}
