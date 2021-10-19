import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'TelaDeLogin.dart';

class Home extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  _checkHome(context)
  {
    auth.authStateChanges().listen((user) {
      if(user == null)
      {
        Navigator.of(context).push(MaterialPageRoute(builder:(context) => Login()));
      }
    });
  }

  _logout()
  {
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    _checkHome(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Pessoas Cadastradas"),
      ),
      floatingActionButton: IconButton(onPressed:() => _logout(), icon: Icon(Icons.logout)),
      body: Container(

          child: StreamBuilder(
            stream: firestore.collection("alunos").orderBy("nome").snapshots(),
            builder: (context, RetornoDeDados)
            {
              switch (RetornoDeDados.connectionState)
              {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(child: Text("Carregando..."),);
                default:
                  QuerySnapshot<Map<String, dynamic>> dados =
                  RetornoDeDados.data as QuerySnapshot<Map<String, dynamic>>;
                  List<Widget> listaAlunos =[];
                  dados.docs.forEach((element) {
                    Map<String, dynamic> infoAluno = element.data();
                    listaAlunos.add( ListTile (leading: Icon(Icons.person),title: Text(infoAluno["nome"])));
                    listaAlunos.add( ListTile (leading: Icon(Icons.email),title: Text(infoAluno["email"])));
                    /*listaAlunos.add( ListTile(title: Text(infoAluno["senha"])));*/
                  });
                  return (RetornoDeDados.hasData)? Column( children: listaAlunos ) : Text("AINDA NÃO TEM NENHUM ALUNO CADASTRADO");
              }
            },
          )
      ),
    );
  }
}
