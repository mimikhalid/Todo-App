import 'package:app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  const EditTodoScreen({Key? key, required this.todo}) : super(key: key);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _statusDone;
  String errorMessage = '';
  bool isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing todo data
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
    _statusDone = widget.todo.statusDone;

    // Add listeners to validate input
    _titleController.addListener(validateInput);
    _descriptionController.addListener(validateInput);
  }

  void validateInput() {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    bool isDuplicate = Provider.of<TodoProvider>(context, listen: false)
    .todos
    .where((todo) => todo.id != widget.todo.id) // Exclude the current todo
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 16.0),
                CheckboxListTile(
                  title: const Text('Complete task?'),
                  value: _statusDone,
                  onChanged: (value) {
                    setState(() {
                      _statusDone = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero, // Remove default padding
                  controlAffinity: ListTileControlAffinity.leading, // Move checkbox to the left edge
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: isButtonDisabled ? null : _saveChanges,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Set the background color to grey when the button is disabled
                      }
                      return Colors.blue; // Set the background color to blue when the button is enabled
                    }),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('Update'),
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

  void _saveChanges() {
    // Create a new Todo object with updated values
    Todo updatedTodo = Todo(
      id: widget.todo.id,
      title: _titleController.text,
      description: _descriptionController.text,
      statusDone: _statusDone,
      created_at: widget.todo.created_at,
      updated_at: DateTime.now(), // Update the updated_at field with the current time
    );

    // Call editTodo function to update the todo
    Provider.of<TodoProvider>(context, listen: false).editTodo(updatedTodo);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
