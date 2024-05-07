import 'package:flutter/material.dart';
import 'package:tasks_app/db_provider/sqlite_manager.dart';
import 'package:tasks_app/model/task.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
    final Map<String, String> formValues = {
      'name':'',
      'email':''
    };

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text('Etrar Con Este Usuario'),
           SizedBox(
             height: size.height/3.5,
             child: Form(
              key: myFormKey,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   TextFormField(
                     onChanged: (value) {
                        formValues["name"] = value;
                     },
                     decoration: InputDecoration(hintText: "Nombre"),
                     textCapitalization: TextCapitalization.words,
                   ),
                   TextFormField(
                     onChanged: (value) {
                       formValues["email"] = value;
                     },
                     decoration: InputDecoration(hintText: "Correo Electronico"),
                     keyboardType: TextInputType.emailAddress,
                   ),
                   ElevatedButton(onPressed: () {
                    // TODO: comprobar en la base de daros si existe este usuario
                   }, 
                   child: const Text('Entrar')
                   ),
                          
                   TextButton(onPressed: () {
                          // TODO: registrar usuario 
                          FocusScope.of(context).requestFocus(FocusNode());
                          print(formValues);
                          final user = User.fromMap(formValues);
                          SQLiteManager.db.registerUser(user);
                          
                   }, child: const Text('Registro')
                   )
                 ],
               ),
             ),
           )
        ],),
      ),
    );
  }
}