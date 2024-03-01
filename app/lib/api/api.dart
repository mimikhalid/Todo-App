import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'package:http/http.dart' as http;

class TodoProvider with ChangeNotifier {
  TodoProvider() {
    fetchTask();
  }
  List<Todo> _todos = [];

  List<Todo> get todos {
    return [..._todos];
  }

  bool isLoading = false;
  fetchTask() async {
    try {
      isLoading = true;

      final url = Uri.parse('http://10.0.2.2:8000/?format=json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        _todos = data.map<Todo>((e) => Todo.fromJson(e)).toList();
        isLoading = false;
        notifyListeners();
      } else {
        // Handle unexpected status code
        isLoading = false;
        notifyListeners();
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      isLoading = false;
      notifyListeners();
      print('Error fetching data: $e');
    } finally {
      isLoading = false; // Set loading flag to false
      notifyListeners(); // Notify listeners that loading state has changed
    }
  }


  void addTodo(Todo todo) async {
    final url = Uri.parse('http://10.0.2.2:8000');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(todo),
    );
    if (response.statusCode == 201) {
      todo.id=json.decode(response.body)['id'];
      _todos.add(todo);
      notifyListeners();
    }
  }

  void deleteTodo(Todo todo) async {
    final url = Uri.parse('http://10.0.2.2:8000/${todo.id}');
    final response = await http.delete(url);
    if (response.statusCode == 204) {
      _todos.remove(todo);
      notifyListeners();
    }
  }

  void editTodo(Todo updatedTodo) async {
    final url = Uri.parse('http://10.0.2.2:8000/${updatedTodo.id}');

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedTodo.toJson()),
    );

    if (response.statusCode == 200) {
      // Find the index of the todo to be edited
      int index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);

      if (index != -1) {
        // Update the todo with the updated values
        _todos[index] = updatedTodo;
        // Update the updated_at field with the current time
        _todos[index].updated_at = DateTime.now();
        notifyListeners();
      }
    }
  }
}