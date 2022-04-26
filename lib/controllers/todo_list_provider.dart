import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/models/list_todo_model.dart';
import 'package:todo/models/todo_category.dart';
import 'package:todo/models/todo_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final todoListProvider =
    StateNotifierProvider<TodoList, ListOfTodoModel>((ref) {
  return TodoList(ListOfTodoModel(data: []));
});

final categoryTodosProvider =
    Provider.family<ListOfTodoModel, TodoCategory>((ref, category) {
  final todos = ref.watch(todoListProvider);

  return ListOfTodoModel(
    data: todos.data.where((todo) => todo.category == category).toList(),
  );
});

final completedTodosByCategoryProvider =
    Provider.family<ListOfTodoModel, TodoCategory>((ref, category) {
  final todos = ref.watch(categoryTodosProvider(category));

  return ListOfTodoModel(
    data: todos.data.where((todo) => todo.isCompleted).toList(),
  );
});

final uncompletedTodosProvider =
    Provider<ListOfTodoModel>((ref) {
  final todos = ref.watch(todoListProvider);

  return ListOfTodoModel(
    data: todos.data.where((todo) => !todo.isCompleted).toList(),
  );
});

class TodoList extends StateNotifier<ListOfTodoModel> {
  TodoList(ListOfTodoModel initialTodos) : super(initialTodos);

  void overrideData(ListOfTodoModel listOfTodoModel) {
    if (listOfTodoModel.data.isNotEmpty) {
      state = listOfTodoModel;
    }
  }

  /// Adds a new [Todo] to the list
  Todo add(TodoCategory category) {
    Todo todo = Todo(id: _uuid.v4(), category: category);
    state = ListOfTodoModel(data: [
      ...state.data,
      todo
    ]);
    return todo;
  }

  void addSubtask(Todo currentTodo) {
    final oldSubtasks = state.data.where((element) => element.id == currentTodo.id).first.subtasks.data;
    Todo subtask = Todo(id: _uuid.v4(), category: currentTodo.category, description: "Subtask");
    state = ListOfTodoModel(data: [
      for (Todo todo in state.data)
        if (todo.id == currentTodo.id)
          currentTodo.copyWith(subtasks: ListOfTodoModel(data: [...oldSubtasks, subtask]))
        else
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
            subtasks: todo.subtasks,
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
            subtasks: todo.subtasks,
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
