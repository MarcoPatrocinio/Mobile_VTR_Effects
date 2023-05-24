import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CadastroForm extends StatefulWidget{
  const CadastroForm({Key? key}) : super(key: key);

  @override
  _CadastroFormState createState() => _CadastroFormState();
}
class _CadastroFormState extends State<CadastroForm>{
  final db = FirebaseFirestore.instance;
  String email = '';
  String senha = '';
  String confirmarSenha = '';
  final getData = <String, String>{};

  buttonClick() async {
    if(email.isNotEmpty && email.contains('@')) {
      if(senha == confirmarSenha){
        bool emailExist = false;
        db.collection('usuarios').where('email', isEqualTo: email).get().then((snapshot) => {
          if(snapshot.size > 0){
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('Email já cadastrado.'),
                        ElevatedButton(
                          child: const Text('Ok'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                }
            )
          }
          else{
            db.collection('usuarios').count().get().then((snapshot_2) => {
              db.collection('usuarios').doc().set({'id': snapshot_2.count + 1, 'email': email, 'senha': senha, 'produtos': []}),
              Navigator.pop(context)
            })
            //final usersRef = db.collection('usuarios').add()
          }
        });
      }
      else{
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Senhas não conferem.'),
                    ElevatedButton(
                      child: const Text('Ok'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              );
            }
        );
      }
    }
    else{
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Email invalido.'),
                  ElevatedButton(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        child: ListView(
          itemExtent: 70.0,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      color: Color(0xFF000000)
                  ),
                  filled: true,
                  fillColor: Color(0xFFBDB133)
              ),
              textInputAction: TextInputAction.next,
              onChanged: (email) => this.email = email,
            ),
            TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                        color: Color(0xFF000000)
                    ),
                    filled: true,
                    fillColor: Color(0xFFBDB133)
                ),
                textInputAction: TextInputAction.done,
                obscureText: true,
                onChanged: (senha) => this.senha = senha,
            ),
            TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                    labelStyle: TextStyle(
                        color: Color(0xFF000000)
                    ),
                    filled: true,
                    fillColor: Color(0xFFBDB133)
                ),
                textInputAction: TextInputAction.done,
                obscureText: true,
                onChanged: (cSenha) => confirmarSenha = cSenha,
                onFieldSubmitted: ((e) => buttonClick())
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (() => Navigator.pop(context)),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(125, 35))
                  ),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: (() => buttonClick()),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(125, 35))
                  ),
                  child: const Text("Cadastrar-se"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}