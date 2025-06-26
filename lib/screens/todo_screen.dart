import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/todo_provider.dart';

class TodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final todos = provider.todos;

    return Scaffold(
      appBar: AppBar(title: Text("Your To Do")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      hintText: 'Add new task',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        provider.addTodo(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            final editController =
                                TextEditingController(text: todo.title);
                            return AlertDialog(
                              title: Text('Edit Task'),
                              content: TextField(
                                controller: editController,
                                decoration: InputDecoration(
                                    hintText: 'Enter new title'),
                                autofocus: true,
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    final newTitle = editController.text.trim();
                                    if (newTitle.isNotEmpty) {
                                      provider.editTodo(todo, newTitle);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      leading: Checkbox(
                        value: todo.isCompleted,
                        activeColor: Colors.black,
                        onChanged: (_) => provider.toggleTodo(index),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => provider.delete(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text("Your remaining todos: ${provider.remainingTodos}"),
          ],
        ),
      ),
    );
  }
}
