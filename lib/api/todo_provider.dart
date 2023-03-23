import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqlhelper/model/todo_model.dart';

class TodoApi {
  static const baseUrl = 'https://64158dad9a2dc94afe648a37.mockapi.io/note_app/';
   Future<List<Todo>> createAllapi() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<dynamic>;
      return json.map((data) => Todo.fromMap(data)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  static Future<void> create(Todo todo) async {
    final response = await http.post(Uri.parse(baseUrl), body: jsonEncode(todo.toMap()));
  }
}