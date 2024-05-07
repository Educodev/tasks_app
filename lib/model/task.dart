class Task {
  final int id;
  final String title;
  final String description;
  final DateTime creationDate;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.dueDate,
    required this.priority,
    required this.status,
  });
}

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed }

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}

class User {
  final int id = 0;
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}

