class Todo {
  final String id;
  final String title;
  final String description;
  final int status;
 // final String createdAt;

  Todo({required this.id, required this.title, required this.description, 
  required this.status
  });

    factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        status: json['status']
        //createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description, 
    'status' : status
    };
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, description: $description, status: $status }';
  }
}