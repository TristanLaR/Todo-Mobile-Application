import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/controllers/todo_list_provider.dart';
import 'package:todo/models/todo_category.dart';
import 'package:todo/models/todo_model.dart';

class CreateTodo extends HookConsumerWidget {
  CreateTodo({required this.todo, this.todoCategory, Key? key}) : super(key: key);

  final Todo todo;
  final TodoCategory? todoCategory;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textController.text = "";
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
    final category = todoCategory ?? todo.category;

    final subtasks = ref.watch(todoListProvider).data.where((element) => element.id == todo.id).first.subtasks;

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
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      Icon(category.icon, color: Colors.grey),
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
                    padding: EdgeInsets.only(left: 5.0),
                    shrinkWrap: true,
                    children: subtasks.data
                        .map(
                          (todo) => CheckboxListTile(
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
                        )
                        .toList(),
                  ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                    ref.read(todoListProvider.notifier).addSubtask(todo);
                    print(ref.read(todoListProvider).data.where((element) => element.id == todo.id).first.subtasks.data.length);
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
