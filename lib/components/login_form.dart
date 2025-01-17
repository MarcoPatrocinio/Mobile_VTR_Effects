import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vtr_effects/classes/usuario.dart';
import 'package:vtr_effects/pages/page_produtos.dart';
import 'package:vtr_effects/colors/primaria.dart';

class LoginForm extends StatefulWidget{
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm>{
  final db = FirebaseFirestore.instance;
  String login = '';
  String senha = '';

  buttonClick() async {
    final usersRef = db.collection('usuarios').where("email", isEqualTo: login).get().then(
          (querySnapshot) {
        if(querySnapshot.size > 0){
          for (var docSnapshot in querySnapshot.docs) {
            final data = docSnapshot.data();
            Usuario user = Usuario(
                id: data['id'],
                email: data['email'],
                senha: data['senha'],
                produtos: data['produtos'],
                imagem: data['imagem'],
                editando: false
            );
            if (data['senha'] == senha){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PageProdutos(user: user)));
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
                          const Text('Senha incorreta'),
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
                      const Text('email não cadastrado.'),
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
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void goToCadastro(){
    Navigator.pushNamed(context, '/cadastro');
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
                  onFieldSubmitted: ((e) => buttonClick()),
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const InkWell(
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
                      onTap: () => Navigator.pushNamed(context, '/cadastrar'),
                      child: const Text(
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
                        fixedSize: MaterialStateProperty.all(const Size(125, 35)),
                        backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        textStyle: MaterialStateProperty.all(const TextStyle()),
                      ),
                      child: const Text("Login"),
                    ),
                    InkWell(
                      onTap:  () async {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            PageProdutos(user: Usuario(
                              id: -1,
                              email: "email",
                              senha: "senha",
                              produtos: <dynamic>[],
                              imagem: FirebaseFirestore.instance.doc("gs:/vtr-effects.appspot.com/Usuarios/proffile.webp"),
                              editando: false
                              )
                            )
                          )
                        );
                      },
                      child: const Text(
                        "Visitante",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFBDB133),
                            decoration: TextDecoration.underline
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
  }
}