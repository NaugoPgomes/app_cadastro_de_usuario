import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Home.dart';

class Cadastro extends StatelessWidget {
  late String email;
  late String nome;
  late String senha;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _form= new GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  _saveForm(){
    _form.currentState!.save();
    Map<String, dynamic> aluno = {
      "nome": nome,
      "email": email,
      "senha": senha,
      "created_at": DateTime.now()
    };
    auth.createUserWithEmailAndPassword(email: this.email, password: this.senha).then((value) {
      String UserUid = value.user!.uid;
      firestore.collection("alunos").doc(UserUid).set(aluno);
    });

  }

  _authentication(context)
  {
    _form.currentState!.save();
    auth.signInWithEmailAndPassword(email: this.email, password: this.senha).then((value) =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) =>
            Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _form,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Cadastro',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 60.0,
                        color: Colors.blue),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    onSaved: (value) => nome = value!,
                    decoration: InputDecoration(
                      labelText: 'Nome de usuario',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (value) => email = value!,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (value) => senha = value!,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: MaterialButton(
                      onPressed: () => _saveForm() & _authentication(context),
                      color: Colors.blue,
                      child: Text(
                        'CADASTRAR',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
