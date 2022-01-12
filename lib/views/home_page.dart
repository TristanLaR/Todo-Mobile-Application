import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/controllers/todo_list_provider.dart';
import 'package:todo/models/todo_category.dart';
import 'package:todo/views/category_tile.dart';
import 'package:intl/intl.dart';

class Home extends StatefulHookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

final categoryListProvider = Provider<List<TodoCategory>>((ref) {
  return [
    TodoCategory(
        id: "work-01",
        categoryName: "Work",
        icon: Icons.work,
        primaryColor: Color.fromRGBO(245, 68, 113, 1.0),
        secondaryColor: Color.fromRGBO(245, 161, 81, 1.0)),
    TodoCategory(
        id: "personal-01",
        categoryName: "Personal",
        icon: Icons.person,
        primaryColor: Color.fromRGBO(77, 85, 225, 1.0),
        secondaryColor: Color.fromRGBO(93, 167, 231, 1.0)),
    TodoCategory(
        id: "school-01",
        categoryName: "School",
        icon: Icons.school,
        primaryColor: Color.fromRGBO(61, 188, 156, 1.0),
        secondaryColor: Color.fromRGBO(61, 212, 132, 1.0)),
  ];
});

final pageViewIndexProvider = StateProvider<int>((ref) => 0);

class HomeState extends ConsumerState<Home> {
  EdgeInsets _leftPadding = const EdgeInsets.only(left: 50.0);

  @override
  Widget build(BuildContext context) {
    final uncompletedTodos = ref.watch(uncompletedTodosProvider);
    final category = ref.watch(categoryListProvider);
    final currentCategory = ref.watch(pageViewIndexProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            category[currentCategory].secondaryColor,
            category[currentCategory].primaryColor
          ],
          begin: Alignment(1, -1),
          end: Alignment(-1, 1),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("TODO"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            Padding(
              padding: _leftPadding,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(5, 5),
                        blurRadius: 15)
                  ],
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/16025433?v=4"),
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Padding(
              padding: _leftPadding,
              child: Text(
                "Hello, Tristan",
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 50.0, bottom: 5.0),
              child: Text(
                "Impossible is for the unwilling",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: _leftPadding,
              child: Text(
                "You have ${uncompletedTodos.data.length} tasks left to do today",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Padding(
              padding: _leftPadding,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "TODAY: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: DateFormat.yMMMMd().format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 20,
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return CategoryTile(context: context, index: index);
                },
                scrollDirection: Axis.horizontal,
                controller: PageController(viewportFraction: 0.8),
                itemCount: ref.watch(categoryListProvider).length,
                onPageChanged: (page) {
                  ref.read(pageViewIndexProvider.state).state = page;
                },
              ),
            ),
            Spacer(
              flex: 4,
            )
          ],
        ),
      ),
    );
  }
}
