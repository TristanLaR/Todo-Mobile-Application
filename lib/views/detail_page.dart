import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/controllers/todo_list_provider.dart';
import 'package:todo/models/todo_category.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/views/create_todo.dart';
import 'package:animations/animations.dart';

class DetailPage extends HookConsumerWidget {
  const DetailPage({required this.todoCategory, Key? key}) : super(key: key);

  final TodoCategory todoCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(categoryTodosProvider(todoCategory));
    final completedTodos =
        ref.watch(completedTodosByCategoryProvider(todoCategory));
    final percentComplete = (todos.data.length == 0)
        ? 0.0
        : completedTodos.data.length / todos.data.length;
    return Stack(
      children: [
        Hero(
          tag: todoCategory.id + "_background",
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Material(
              color: Colors.transparent,
              type: MaterialType.transparency,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.grey,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 40.0, 0.0, 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0, left: 30.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: todoCategory.id + "_icon",
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.withAlpha(70),
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            todoCategory.icon,
                            color: todoCategory.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0, left: 30.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: todoCategory.id + "_numTasks",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "${ref.watch(categoryTodosProvider(todoCategory)).data.length.toString()} Tasks",
                          style: TextStyle(),
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0, left: 30.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: todoCategory.id + "_title",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          todoCategory.categoryName,
                          style: TextStyle(fontSize: 30.0),
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 20.0, right: 30.0, left: 30.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: todoCategory.id + "_progressBar",
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentComplete,
                                backgroundColor: Colors.grey.withAlpha(50),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  todoCategory.primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                  (percentComplete * 100).round().toString() +
                                      "%"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(left: 5.0),
                    shrinkWrap: true,
                    children: todos.data
                        .map(
                          (todo) => _OpenContainerWrapper(
                            todo: todo,
                            closedChild: CheckboxListTile(
                              activeColor: Colors.grey,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: todo.isCompleted,
                              title: Text(
                                todo.description,
                                style: todo.isCompleted
                                    ? TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.withOpacity(0.6),
                                      )
                                    : TextStyle(),
                              ),
                              secondary: Visibility(
                                visible: todo.isCompleted,
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => {
                                    ref
                                        .read(todoListProvider.notifier)
                                        .removeTodo(todo)
                                  },
                                ),
                              ),
                              onChanged: (bool? newState) => {
                                ref
                                    .read(todoListProvider.notifier)
                                    .toggleCompleted(todo.id)
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 40.0, right: 10.0),
            child: Hero(
              tag: todoCategory.id + "_add_todo",
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 1),
                      blurRadius: 6,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(90),
                  gradient: LinearGradient(
                    colors: [
                      todoCategory.secondaryColor,
                      todoCategory.primaryColor
                    ],
                    begin: Alignment(1, -1),
                    end: Alignment(-1, 1),
                  ),
                ),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () => {
                    // ref
                    //     .read(todoListProvider.notifier)
                    //     .add("Todo item #${todos.data.length + 1}", todoCategory)
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) =>
                            CreateTodo(todoCategory: todoCategory),
                        transitionDuration: Duration(milliseconds: 700),
                        reverseTransitionDuration: Duration(milliseconds: 700),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          final tween =
                              Tween(begin: Offset(0.0, 1.0), end: Offset.zero);
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    )
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.todo,
    required this.closedChild,
  });

  final Todo todo;
  final Widget closedChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return CreateTodo(todo: todo);
      },
      openColor: theme.cardColor,
      closedElevation: 0,
      transitionType: ContainerTransitionType.fade,
      transitionDuration: Duration(milliseconds: 500),
      closedColor: theme.cardColor,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onLongPress: () {
            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}
