import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/controllers/subtask_provider.dart';
import 'package:todo/controllers/todo_list_provider.dart';
import 'package:todo/models/list_todo_model.dart';
import 'package:todo/models/todo_category.dart';
import 'package:todo/models/todo_model.dart';

final todoTaskProvider = StateProvider((ref) => '');

class CreateTodo extends HookConsumerWidget {
  CreateTodo({required this.todo, this.todoCategory, Key? key})
      : super(key: key);

  final Todo todo;
  final TodoCategory? todoCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();

    useEffect(() {
      textController.text = ref
          .read(todoListProvider.notifier)
          .state
          .data
          .firstWhere((element) => todo.id == element.id)
          .description;
    }, [textController]);

    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
    final category = todoCategory ?? todo.category;

    final subtasks = ref.watch(subtaskProvider(todo));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        title: todoCategory != null
            ? Text(
                "New Task",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              )
            : Text(
                "Edit Task",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(
              flex: 4,
            ),
            Text(
              "What tasks are you planning to perform?",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: TextField(
                controller: textController,
                textCapitalization: TextCapitalization.sentences,
                decoration: null,
                style: TextStyle(
                  fontSize: 28.0,
                ),
                autofocus: false,
              ),
            ),
            Divider(),
            Spacer(
              flex: 4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(category!.icon, color: Colors.grey),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          category.categoryName,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                ListView(
                  shrinkWrap: true,
                  children: subtasks.data
                      .map(
                        (subtask) => _SubtaskField(
                          parentTodo: todo,
                          subtask: subtask,
                        ),
                      )
                      .toList(),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.grey),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Add a new subtask",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    print("tap");
                    ref.read(subtaskProvider(todo).notifier).add();
                    print(ref.read(subtaskProvider(todo)).data.length);
                  },
                ),
                // SizedBox(height: 50),
                // Divider(),
              ],
            ),
            Spacer(
              flex: 18,
            )
          ],
        ),
      ),
      bottomSheet: Hero(
        tag: category.id + "_add_todo",
        child: Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [category.secondaryColor, category.primaryColor],
              begin: Alignment(1, -1),
              end: Alignment(-1, 1),
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              ref
                  .read(todoListProvider.notifier)
                  .edit(id: todo.id, description: textController.text);
              Navigator.of(context).pop();
            },
            child: Icon(Icons.add),
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent, shadowColor: Colors.transparent),
          ),
        ),
      ),
    );
  }
}

class _SubtaskField extends HookConsumerWidget {
  const _SubtaskField(
      {required this.subtask, required this.parentTodo, Key? key})
      : super(key: key);

  final Todo subtask;
  final Todo parentTodo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final subtaskState = ref.read(subtaskProvider(parentTodo).notifier).state;

    useEffect(() {
      textController.text = subtaskState
          .data
          .firstWhere((element) => subtask.id == element.id)
          .description;
    }, [subtask, subtaskState]);

    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));

    return CheckboxListTile(
      activeColor: Colors.grey,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: subtask.isCompleted,
      title: TextField(
        controller: textController,
        textCapitalization: TextCapitalization.sentences,
        decoration: null,
        style: subtask.isCompleted
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey.withOpacity(0.6),
              )
            : TextStyle(),
        autofocus: false,
      ),
      secondary: Visibility(
        visible: subtask.isCompleted,
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => {
            ref.read(subtaskProvider(parentTodo).notifier).removeTodo(subtask)
          },
        ),
      ),
      onChanged: (bool? newState) => {
        print("complete"),
        ref
            .read(subtaskProvider(parentTodo).notifier)
            .toggleCompleted(subtask.id)
      },
    );
  }
}
