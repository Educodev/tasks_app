import 'package:flutter/material.dart';
import 'package:tasks_app/db_provider/sqlite_manager.dart';
import 'package:tasks_app/model/task.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<List<Map>> taskFuture = SQLiteManager.db.getTasks(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Tareas'),
        actions: [
          TextButton(
            onPressed: () async {
              await _makeTask();
            },
            child: const Text('Crear Tarea'),
          ),
        ],
      ),
      body: FutureBuilder<List<Map>>(
        future: taskFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Map> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task['title']),
                  subtitle: Text(task['description']),
                  // Agrega más detalles de la tarea si es necesario
                );
              },
            );
          } else {
            return Center(child: Text('No se encontraron tareas.'));
          }
        },
      ),
    );
  }

  Future<void> _makeTask() async {
    DateTime creationDate = DateTime.now();
    DateTime dueDate = DateTime.now().add(Duration(days: 7));
    TaskPriority priority = TaskPriority.medium;
    TaskStatus status = TaskStatus.pending;

    final task = Task(
      userId: 1,
      title: 'Comprar el pan',
      description: 'Recordar que hay que comprar el pan',
      creationDate: creationDate,
      dueDate: dueDate,
      priority: priority,
      status: status,
    );

    await SQLiteManager.db.createNewTask(task);
  }
}
