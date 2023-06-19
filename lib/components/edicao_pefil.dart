import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vtr_effects/pages/page_produtos.dart';

import '../classes/usuario.dart';
import '../colors/primaria.dart';

class EdicaoPerfil extends StatefulWidget{
  final Usuario user;
  const EdicaoPerfil(this.user, {super.key});

  @override
  _EdicaoPerfilState createState() => _EdicaoPerfilState(user);
}
class _EdicaoPerfilState extends State<EdicaoPerfil>{
  final db = FirebaseFirestore.instance;
  final Usuario user;

  late String email;
  late String senha;
  late DocumentReference imagem;
  late String confirmarSenha;
  late bool imagemAlterada = false;
  late File tempFile;
  _EdicaoPerfilState(this.user);

  @override
  void initState(){
    super.initState();
    email = user.email;
    senha = user.senha;
    imagem = user.imagem;
    confirmarSenha = "";
  }

  void logout(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void atualizar() async {
    if(user.senha == senha){
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(context, MaterialPageRoute(builder: (context) => PageProdutos(user: Usuario(
          id: user.id,
          email: user.email != email ? email : user.email,
          senha: confirmarSenha.isNotEmpty? confirmarSenha : user.senha,
          produtos: user.produtos,
          imagem: imagem,
          editando: false
      ))));
      db.collection('usuarios').where('id', isEqualTo: user.id).get().then((snapshot) async {
        for(var doc in snapshot.docs){
          final docRef = db.collection('usuarios').doc(doc.id);
          final dados = doc.data();
          if(dados['email'] != email){
            docRef.update({"email": email});
          }
          if(confirmarSenha.isNotEmpty){
            docRef.update({"senha": confirmarSenha});
          }
          if(imagemAlterada) {
            FirebaseStorage.instance.refFromURL(user.imagem.path.replaceAll('gs:/', 'gs://')).delete();
            final newImgRef = FirebaseStorage.instance.ref().child('Usuarios/foto_perfil_${email}_${user.id}');
            await newImgRef.putFile(tempFile);
            imagem = db.doc('/gs:/vtr-effects.appspot.com/${newImgRef.fullPath}');
            docRef.update({"imagem": imagem});
            await db.collection('produtos').get().then((snap) async {
              for (var prod in snap.docs) {
                final dataProd = prod.data();
                final prodDocRef = db.collection('produtos').doc(prod.id);
                var aux = [];
                for (var com in dataProd['comentario']) {
                  if (com['idUser'] == user.id) {
                    aux.add({
                      'com': com['com'],
                      'email': email,
                      'idCom': com['idCom'],
                      'idUser': user.id,
                      'imagemUser': imagem
                    });
                  }
                  else {
                    aux.add(com);
                  }
                }
                prodDocRef.update({'comentario': aux});
              }
            });
          }
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

  void mudarFoto() async {
    final result  = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'webp', 'jpeg']
    );
    if(result != null){
      final info = result.files.first;
      final String? aux = info.path;
      tempFile = File(aux!);
      try {
        setState(() {});
        imagemAlterada = true;
      } on FirebaseException catch (e) {
        debugPrint("Erro ao fazer upload da imagem: $e");
      }
    }
  }

  Widget getImage(){
    if(imagemAlterada){
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
              backgroundImage: Image.file(tempFile).image,
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
    final storageRef = FirebaseStorage.instance.refFromURL(imagem.path.replaceAll('gs:/', 'gs://'));
    final imgUrl = storageRef.getDownloadURL();
    return FutureBuilder(
      future: imgUrl,
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null){
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
                  backgroundImage: Image.network(snapshot.data ?? '').image,
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
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
       child: SingleChildScrollView(
         child: Flex(
           direction: Axis.vertical,
           mainAxisAlignment: MainAxisAlignment.spaceAround,
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
               child:  TextFormField(
                 decoration: const InputDecoration(
                     labelText: 'Email',
                     labelStyle: TextStyle(
                         color: Color(0xFF000000)
                     ),
                     filled: true,
                     fillColor: Color(0xFFBDB133)
                 ),
                 textInputAction: TextInputAction.next,
                 initialValue: user.email,
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
                 initialValue: user.senha,
                 onChanged: (senha) => this.senha = senha,
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(5),
               child: TextFormField(
                   decoration: const InputDecoration(
                       labelText: 'Nova Senha',
                       labelStyle: TextStyle(
                           color: Color(0xFF000000)
                       ),
                       filled: true,
                       fillColor: Color(0xFFBDB133)
                   ),
                   textInputAction: TextInputAction.done,
                   obscureText: true,
                   onChanged: (cSenha) => confirmarSenha = cSenha,
                   onFieldSubmitted: ((e) => debugPrint("jota"))
               ),
             ),
             Flex(
               direction: Axis.horizontal,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(left: 15, right: 5),
                   child: ElevatedButton(
                     onPressed: (() => atualizar()),
                     style: ButtonStyle(
                       fixedSize: MaterialStateProperty.all(const Size(150, 35)),
                       backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                       foregroundColor: MaterialStateProperty.all(Colors.black),
                       textStyle: MaterialStateProperty.all(const TextStyle()),
                     ),
                     child: const Text("Atualizar"),
                   ),
                 )
               ],
             ),
           ],
         ),
       )
    );
  }
}