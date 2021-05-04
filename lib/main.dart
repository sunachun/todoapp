import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/add/add_page.dart';
import 'package:todo_app/main_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getTodoListRealtime(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('todo-app'),
            actions: [
              // ignore: deprecated_member_use
              Consumer<MainModel>(builder: (context, model, child) {
                final isActive = model.checkShouldActiveCompleteButton();
                // ignore: deprecated_member_use
                return FlatButton(
                  onPressed: isActive
                      ? () async {
                          await model.deleteCheckedItems();
                        }
                      : null,
                  child: Text(
                    '完了',
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                );
              }),
            ],
          ),
          drawer: Drawer(
            child: Consumer<MainModel>(builder: (context, model, child) {
              return ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Text('ヘッダー'),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text("タスクを追加"),
                    // ignore: deprecated_member_use
                    trailing: RaisedButton(
                      child: Icon(
                        Icons.settings,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPage(model),
                            ));
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("アイテム2"),
                    trailing: Icon(Icons.settings),
                  ),
                ],
              );
            }),
          ),
          body: Consumer<MainModel>(builder: (context, model, child) {
            final todoList = model.todoList;
            return ListView(
              children: todoList
                  .map(
                    (todo) => CheckboxListTile(
                      title: Text(todo.title),
                      value: todo.isDone,
                      onChanged: (bool value) {
                        todo.isDone = !todo.isDone;
                        model.reload();
                      },
                    ),
                  )
                  .toList(),
            );
          }),
          floatingActionButton:
              Consumer<MainModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPage(model),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Icon(Icons.tag_faces),
            );
          })),
    );
  }
}
