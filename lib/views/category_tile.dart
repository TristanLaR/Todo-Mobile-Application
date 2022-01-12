import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/controllers/todo_list_provider.dart';
import 'package:todo/views/detail_page.dart';
import 'package:todo/views/home_page.dart';

class CategoryTile extends HookConsumerWidget {
  const CategoryTile({required this.context, required this.index, Key? key})
      : super(key: key);

  final BuildContext context;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Get [TodoCategory]s
    final todoCategory = ref.watch(categoryListProvider);

    /// Get [Todo] in [TodoCategory]
    final todoByCategory =
        ref.watch(categoryTodosProvider(todoCategory[index]));

    /// Get Completed [Todo] in a category
    final completedTodosByCategory =
        ref.watch(completedTodosByCategoryProvider(todoCategory[index]));

    /// Calculate % completed from Todo in a category
    final percentComplete = (todoByCategory.data.length == 0)
        ? 0.0
        : completedTodosByCategory.data.length / todoByCategory.data.length;
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) =>
                  DetailPage(todoCategory: todoCategory[index]),
              transitionDuration: Duration(milliseconds: 1000),
              reverseTransitionDuration: Duration(milliseconds: 1000),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity:
                      animation.drive(CurveTween(curve: Curves.easeInQuint)),
                  child: child,
                );
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(70),
                offset: Offset(3.0, 10.0),
                blurRadius: 15.0,
              ),
            ],
          ),
          height: 250.0,
          child: Stack(
            children: [
              Hero(
                tag: todoCategory[index].id + "_background",
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Hero(
                                tag: todoCategory[index].id + "_icon",
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                      todoCategory[index].icon,
                                      color: todoCategory[index].primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Hero(
                      tag: todoCategory[index].id + "_numTasks",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "${todoByCategory.data.length.toString()} Tasks",
                          style: TextStyle(),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Spacer(),
                    Hero(
                      tag: todoCategory[index].id + "_title",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          todoCategory[index].categoryName,
                          style: TextStyle(fontSize: 30.0),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Spacer(),
                    Hero(
                      tag: todoCategory[index].id + "_progressBar",
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentComplete,
                                backgroundColor: Colors.grey.withAlpha(70),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    todoCategory[index].primaryColor),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                  (percentComplete * 100).round().toString() +
                                      "%"),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
