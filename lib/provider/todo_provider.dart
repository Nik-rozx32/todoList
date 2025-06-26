import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todolist/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  late Box<Todo> _todoBox;

  List<Todo> get todos => _todoBox.values.toList();

  int get remainingTodos => todos.where((todo) => !todo.isCompleted).length;

  Future<void> init() async {
    _todoBox = await Hive.openBox<Todo>('todoBox');
    notifyListeners();
  }

  void addTodo(String title) {
    final todo = Todo(title: title);
    _todoBox.add(todo);
    notifyListeners();
  }

  void editTodo(Todo todo, String newTitle) {
    todo.title = newTitle;
    todo.save();
    notifyListeners();
  }

  void toggleTodo(int index) {
    final todo = _todoBox.getAt(index);
    todo?.isCompleted = !(todo?.isCompleted ?? false);
    todo?.save();
    notifyListeners();
  }

  void delete(int index) {
    _todoBox.deleteAt(index);
    notifyListeners();
  }
}
