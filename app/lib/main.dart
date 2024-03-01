import 'package:app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/add_todo.dart';
import 'screens/edit_todo.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> TodoProvider(),
      child:  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.blue,
        ),
        home: HomePage(),
      )
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoP = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontWeight: FontWeight.bold, // Optionally set the font weight
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: todoP.isLoading
        ? const Center(
            child: CircularProgressIndicator(), // Show loading indicator
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: todoP.todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = todoP.todos[index];
              return Card(
                color: Colors.grey[90],
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => EditTodoScreen(todo: todo),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.orange),
                      ),
                      IconButton(
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Delete'),
                                content: Text('Are you sure you want to delete this Todo?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Call deleteTodo method from TodoProvider and pass the Todo item
                                      Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo);
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                  title: Text(todo.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todo.description),
                      Text(
                        todo.statusDone != null ? (todo.statusDone ? "Completed" : "Pending") : "Unknown",
                        style: TextStyle(
                          color: todo.statusDone != null
                              ? (todo.statusDone ? Colors.green : Colors.red)
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Date Created: ${DateFormat('dd MMM yyyy : hh.mm a').format(todo.created_at)}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),

                      Text('Last Modified: ${DateFormat('dd MMM yyyy : hh.mm a').format(todo.updated_at)}',
                      style: const TextStyle(
                          fontSize: 12, ),
                      ),
                    ],
                  ),
                ),
              );

            },
          ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddTodoScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

}
