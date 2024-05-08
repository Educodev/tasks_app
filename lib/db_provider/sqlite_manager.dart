import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/task.dart';

class SQLiteManager {
  
  static Database? _database;
  // Instancia: singleton
  static final SQLiteManager db = SQLiteManager._();

// Constructor Privado
  SQLiteManager._();

// El get es el que vamos a llamar para acceder a la base de datos desde fuera de la clase, con el gestionamos la propiedad _database privada
// Debe ser asyncrono ya que el proceso para obtener la base de daros no es sicrono y tiene que esperar.
   get database async {
    // Devuelve la base de datos en caso de que ya se haya instanciado de antes y esta contenga una base de deatos para no realizar de nuevo el proceso de obtener la base de datos
    if (_database != null) return _database;

    // si la propiedad pribada _database no contiene nada entonces se ejecuta esta linea donde obtenemos la base de datos
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    // Path de donde almacenemos nuestra base de daro

    // El Directory lo obtenfo de la libreria 'dart:io' y  el getApplicationDocumentsDirectory de la libreria path_provider previamente importada.
    // Esto es para obtener la ruta donde se almacena nuestra base de datos para poder acceder a ella fisicamente desde nuestro directorio de archivos y poder manipularla de forma manual.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // Esto es el string de la ruta junto con el nombre de nuestra base de datos
    final path = join(documentsDirectory.path, 'Tasks.db');
    // Necesito pintar la ruta para acceder desde el directorio de archivos
    print(path);
    // Aqui creamos la base de datos si no existe y es lo que devolvemos en el metodo
    // le pasamos la Ruta, y la version(para controlar si hacemos cambios estructurales a lo largo del proyecto, cuando se vuelva a ejecutar este metodo y si previamente hemos aumentado la version entonces se vuelve a disparar la creacion de toda la estructura de la base de datos )
    return await openDatabase(path, version: 3, onOpen: ( db ) {}, onCreate: (Database db, int version) async {
      await db.execute(testTable);
      await db.execute(userTable);
      await db.execute(taskTable);

    });
    

  }

// Future<void> createNewTask(Task task) async {
//    final Database db = await database;
//     await db.rawInsert('''
//       INSERT INTO Task(id, userID, title, description, creationDate, dueDate, priority, status)
//       VALUES(${task.id}, ${task.userId}, '${task.title}', '${task.description}', ${task.creationDate.millisecondsSinceEpoch}, ${task.dueDate.millisecondsSinceEpoch}, ${task.priority.index}, ${task.status.index})
//      ''');


// }

Future<bool> createNewTask(Task task) async {
  final Database db = await database;
  final int id = await db.rawInsert('''
    INSERT INTO Task(userID, title, description, creationDate, dueDate, priority, status)
    VALUES(${task.userId}, '${task.title}', '${task.description}', ${task.creationDate.millisecondsSinceEpoch}, ${task.dueDate.millisecondsSinceEpoch}, ${task.priority.index}, ${task.status.index})
  ''');
  return (id != -1);
}

Future<List<Map>> getTasks(int userID) async {
  final Database db = await database;
  List<Map> result = await db.rawQuery('''
    SELECT * FROM Task WHERE userID = $userID
  ''');
  print(result);
  return result;
  }


  Future<int> registerUser(User user) async {
  final Database db = await database;
  int userId = await db.rawInsert('''
    INSERT INTO User(name, email)
    VALUES('${user.name}', '${user.email}')
  ''');
  return userId;
}

Future<bool> login(String name, String email) async {
  final Database db = await database;
  List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT * FROM User WHERE name = '$name' AND email = '$email'
  ''');
  print(result);
  return result.isNotEmpty;
  }


final String userTable= 'CREATE TABLE User (id INTEGER PRIMARY KEY, name TEXT, email TEXT)';
final String testTable = 'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)';
final String taskTable = 'CREATE TABLE Task (id INTEGER PRIMARY KEY, userID INTEGER, title TEXT, description TEXT, creationDate INTEGER, dueDate INTEGER, priority INTEGER, status INTEGER)';

  
}


