import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../colors/primaria.dart';

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
  late File imagem;
  bool imagemAlterada = false;

  void mudarFoto() async {
    final result  = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'webp', 'jpeg']
    );
    if(result != null){
      final info = result.files.first;
      //final newImgRef = FirebaseStorage.instance.ref().child('Usuarios/${email}_${info.name}');
      final String? aux = info.path;
      final File imgFile = File(aux!);
      try {
        //await newImgRef.putFile(imgFile);
        //imagem = db.doc('/gs:/vtr-effects.appspot.com/${newImgRef.fullPath}');
        imagem = imgFile;
        setState(() {});
        imagemAlterada = true;
      } on FirebaseException catch (e) {
        debugPrint('$e');
      }
    }
  }

  Widget getImage(){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                spreadRadius: 6,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 100,
            backgroundImage: imagemAlterada? Image.file(imagem).image : Image.asset('lib/assets/proffile.webp').image,
          ),
        ),
        GestureDetector(
          onTap: () {
            mudarFoto();
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.yellow,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }

  buttonClick() async {

    if(email.isNotEmpty && email.contains('@')) {
      if(imagemAlterada){
        if(senha == confirmarSenha){
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
              db.collection('usuarios').orderBy('id', descending: true).limit(1).get().then((snapshot_2) async {
                final newImgRef = FirebaseStorage.instance.ref().child('Usuarios/new_user_id_${snapshot_2.docs[0].data()['id'] + 1}');
                await newImgRef.putFile(imagem);
                DocumentReference imgAux = db.doc('/gs:/vtr-effects.appspot.com/${newImgRef.fullPath}');
                await db.collection('usuarios').doc().set({
                  'id': snapshot_2.docs[0].data()['id'] + 1,
                  'email': email,
                  'senha': senha,
                  'produtos': [],
                  'imagem': imgAux
                });
              }),
              Navigator.pop(context)
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
                    const Text('Imagem de perfil necessaria.'),
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
      child: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    getImage(),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
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
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
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
            ),Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
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
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child:Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: (() => Navigator.pop(context)),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(125, 35)),
                      backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      textStyle: MaterialStateProperty.all(const TextStyle()),
                    ),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: (() => buttonClick()),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(125, 35)),
                      backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      textStyle: MaterialStateProperty.all(const TextStyle()),
                    ),
                    child: const Text("Cadastrar-se"),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}