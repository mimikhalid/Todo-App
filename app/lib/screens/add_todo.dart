import 'package:app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final todoTitleController = TextEditingController();
  final todoDescController = TextEditingController();
  bool isButtonDisabled = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    todoTitleController.addListener(validateInput);
    todoDescController.addListener(validateInput);
  }

  @override
  void dispose() {
    todoTitleController.dispose();
    todoDescController.dispose();
    super.dispose();
  }

  void validateInput() {
    final String title = todoTitleController.text;
    final String description = todoDescController.text;

    bool isDuplicate = Provider.of<TodoProvider>(context, listen: false)
        .todos
        .any((todo) => todo.title == title);

    String newErrorMessage = '';
    if (title.isEmpty) {
      newErrorMessage = 'Title cannot be empty';
    } else if (isDuplicate) {
      newErrorMessage = 'Title must be unique';
    } else if (description.isEmpty) {
      newErrorMessage = 'Description cannot be empty';
    } else if (title.length > 50) {
      newErrorMessage = 'Title exceeds maximum length (50 characters)';
    } else if (description.length > 200) {
      newErrorMessage = 'Description exceeds maximum length (200 characters)';
    }

    setState(() {
      errorMessage = newErrorMessage;
      isButtonDisabled = errorMessage.isNotEmpty;
    });
  }

  void onAdd() {
    final String textVal = todoTitleController.text;
    final String descVal = todoDescController.text;

    if (textVal.isNotEmpty && descVal.isNotEmpty) {
      final DateTime now = DateTime.now();
      final Todo todo = Todo(title:  textVal, description: descVal, statusDone: false, created_at: now, updated_at: now,);
      Provider.of<TodoProvider>(context, listen:false).addTodo(todo);
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: todoTitleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: todoDescController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: isButtonDisabled ? null : onAdd,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Set the background color to grey when the button is disabled
                      }
                      return Colors.blue; // Set the background color to blue when the button is enabled
                    }),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('Save'),
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}