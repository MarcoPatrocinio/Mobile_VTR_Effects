import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vtr_effects/pages/page_produtos.dart';

//import 'package:http/http.dart' as http;
//import '../../pages/page_select_function.dart';

/*
Future<void> checkCredencials(BuildContext context, String pLogin, String pSenha) async {
  final response = await http.get(Uri.parse("http://192.168.1.100:8080/user?usuario=$pLogin"));
  final data = jsonDecode(response.body)[0];
  final mensagem = data != null ?'Senha Incorreta.': 'Usuario não existe.';
  if (data != null) {
    if (data['senha'] == pSenha) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const PageSelectFunction()
        ),
      );
    }
    else{
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(mensagem),
                    ElevatedButton(
                      child: const Text('Ok.'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
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
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(mensagem),
                  ElevatedButton(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
*/

class LoginForm extends StatefulWidget{
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm>{
  final db = FirebaseFirestore.instance;
  String login = '';
  String senha = '';
  final getData = Map<String, String>();
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };
  buttonClick() {
    db.collection("users").add(user);
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
                  onChanged: (login) => this.login = login,
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
                  onFieldSubmitted: ((e) => debugPrint("a"))//checkCredencials(context, login, e)),
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    InkWell(
                      child: Text(
                        "Esqueci a senha",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFFBDB133),
                          decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                    InkWell(
                      child: Text(
                        "Novo Cadastro",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFBDB133),
                            decoration: TextDecoration.underline
                        ),
                      ),
                    )
                  ],
                ),
                Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (() => buttonClick()),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(125, 35))
                      ),//Navigator.pushNamed(context, '/produtos'))
                      child: const Text("Login"),
                    ),//checkCredencials(context, login, senha)), child: const Text('Entrar'))
                    const InkWell(
                      child: Text(
                        "Visitante",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFBDB133),
                            decoration: TextDecoration.underline
                        ),
                      ),
                    )
                    /*ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(125, 35))
                        ),
                        onPressed: (() => debugPrint("")), child: const Text("Visitante")
                    )*/
                  ],
                )
              ],
            ),
          ),
        );
  }
}