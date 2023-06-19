import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../classes/produto.dart';
import '../classes/usuario.dart';
import '../colors/primaria.dart';


class VejaMais extends StatefulWidget{
  final Usuario usuario;
  final Produto produto;
  const VejaMais({super.key, required this.usuario, required this.produto});

  @override
  _VejaMaisState createState() => _VejaMaisState(usuario, produto);
}
class _VejaMaisState extends State<VejaMais>{
  double? _progressFirmware;
  double? _progressManual;
  double? _progressGarantia;
  late String novoComentario;
  final Usuario usuario;
  final Produto produto;
  _VejaMaisState(this.usuario, this.produto);

  Widget verManual(){
    if(usuario.produtos.contains(produto.id)){
      if (_progressManual != null){
        return const CircularProgressIndicator();
      }
      return ElevatedButton(
        onPressed:  () async {
          final storageRef = FirebaseStorage.instance.refFromURL(produto.manual.path.replaceAll('gs:/', 'gs://'));
          final downloadUrl = await storageRef.getDownloadURL();
          FileDownloader.downloadFile(
              url: downloadUrl.trim(),
              onProgress: (name, progress) {
                setState(() {
                  _progressManual = progress;
                });
              },
              onDownloadCompleted: (value) async {
                final result  = await FilePicker.platform.pickFiles();
                if(result != null){
                  final String? aux = result.files.first.path;
                  final File f = File(aux!);
                  OpenFile.open(f.path);
                }
                //
                setState(() {
                  _progressManual = null;
                });
              }
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          textStyle: MaterialStateProperty.all(const TextStyle()),
        ),
        child: const Text("Baixar Manual do Produto"),
      );
    }
    return Container();
  }

  Widget verFirmware(){
    if(usuario.produtos.contains(produto.id)){
      if (_progressFirmware != null){
        return const CircularProgressIndicator();
      }
      return ElevatedButton(
        onPressed:  () async {
          final storageRef = FirebaseStorage.instance.refFromURL(produto.firmware.path.replaceAll('gs:/', 'gs://'));
          final downloadUrl = await storageRef.getDownloadURL();
          FileDownloader.downloadFile(
              url: downloadUrl.trim(),
              onProgress: (name, progress) {
                setState(() {
                  _progressFirmware = progress;
                });
              },
              onDownloadCompleted: (value)  {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Arquivo baixado na pasta de downloads do dispositivo'),
                              ElevatedButton(
                                child: const Text('Ok'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ),
                        );
                      }
                  );
                setState(() {
                  _progressFirmware = null;
                });
              }
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          textStyle: MaterialStateProperty.all(const TextStyle()),
        ),
        child: const Text("Baixar Firmware Atualizado"),
      );
    }
    return Container();
  }

  Widget verTermo(){
    if(usuario.produtos.contains(produto.id)){
      if (_progressGarantia != null){
        return const CircularProgressIndicator();
      }
      return ElevatedButton(
        onPressed:  () async {
          final storageRef = FirebaseStorage.instance.refFromURL(produto.garantia.path.replaceAll('gs:/', 'gs://'));
          final downloadUrl = await storageRef.getDownloadURL();
          FileDownloader.downloadFile(
              url: downloadUrl.trim(),
              onProgress: (name, progress) {
                setState(() {
                  _progressGarantia = progress;
                });
              },
              onDownloadCompleted: (value) async {
                final result  = await FilePicker.platform.pickFiles();
                if(result != null){
                  final String? aux = result.files.first.path;
                  final File f = File(aux!);
                  OpenFile.open(f.path);
                }
                setState(() {
                  _progressGarantia = null;
                });
              }
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          textStyle: MaterialStateProperty.all(const TextStyle()),
        ),
        child: const Text("Baixar Termo de Garantia"),
      );
    }
    return Container();
  }

  void addComentario()  {
    final db = FirebaseFirestore.instance;
    db.collection('produtos').where('id', isEqualTo: produto.id).get().then((snap) async{
      for(var prodDoc in snap.docs){
        final prodData = prodDoc.data();
        var aux = prodData['comentario'];
        aux.add({
          'com': novoComentario,
          'email': usuario.email,
          'idCom': produto.comentarios.length + 1,
          'idUser': usuario.id,
          'imagemUser': usuario.imagem
        });
        await db.collection('produtos').doc(prodDoc.id).update({'comentario': aux});
        produto.comentarios = aux;
        setState(() {});
      }
    });
    Navigator.pop(context);
  }

  Widget verAddComentario(){
    if(usuario.produtos.contains(produto.id)){
      return ElevatedButton(
        onPressed:  () async {
          showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF04121F),
              builder: (BuildContext context) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          maxLines: 6,
                          decoration: const InputDecoration(
                              labelText: '',
                              labelStyle: TextStyle(
                                  color: Color(0xFF000000)
                              ),
                              filled: true,
                              fillColor: Color(0xFFBDB133)
                          ),
                          textInputAction: TextInputAction.done,
                          onChanged: (coment) => novoComentario = coment,
                          onFieldSubmitted: (e) => addComentario(),
                          autofocus: true,
                        ),
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                              textStyle: MaterialStateProperty.all(const TextStyle()),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                              textStyle: MaterialStateProperty.all(const TextStyle()),
                            ),
                            onPressed: () => addComentario(),
                            child: const Text('Adicionar'),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          textStyle: MaterialStateProperty.all(const TextStyle()),
        ),
        child: const Text("Adicionar Comentario"),
      );
    }
    return Container();
  }

  Widget verFoto(){
    final storageRef = FirebaseStorage.instance.refFromURL(produto.imagem.path.replaceAll('gs:/', 'gs://'));
    final imgUrl =  storageRef.getDownloadURL();
    return FutureBuilder(
      future: imgUrl,
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null){
          return Image.network(snapshot.data ?? '');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      ListView(
        padding: const EdgeInsets.all(20),
        children: [
         verFoto(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child:  Text(
                produto.nome,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
              produto.descricaoDetalhada,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              produto.preco,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white
              ),
            ),
          ),
          verFirmware(),
          verManual(),
          verTermo(),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: PreferredSize(
              preferredSize: const Size.fromHeight(10.0), // altura da borda
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: Color(0xFFBDB133)), // estilo e cor da borda
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              "Avaliações do produto",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFBDB133),
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: PreferredSize(
              preferredSize: const Size.fromHeight(10.0), // altura da borda
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: Color(0xFFBDB133)), // estilo e cor da borda
                  ),
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: produto.comentarios.length,
            itemBuilder: (context, index) {
              final comentario = produto.comentarios[index];
              final storageRef = FirebaseStorage.instance.refFromURL(comentario['imagemUser'].path.replaceAll('gs:/', 'gs://'));
              final imgUrl = storageRef.getDownloadURL();
              return Flex(
                direction: Axis.vertical,
                children: [
                  ListTile(
                    leading: GestureDetector(
                      child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: const BoxDecoration(
                              color: Color(0xB133FF),
                              borderRadius: BorderRadius.all(Radius.circular(50))
                          ),
                          child: FutureBuilder(
                            future: imgUrl,
                            builder: (context, snapshot) {
                              if(snapshot.hasData && snapshot.data != null){
                                return CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(snapshot.data ?? '')
                                );
                              }
                              return const CircularProgressIndicator();
                            },
                          )
                      ),
                    ),
                    title: Text(
                      comentario['email'],
                      style: const TextStyle(
                          color: Color(0xFFBDB133),
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    subtitle: Text(
                      comentario['com'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                  ),
                  PreferredSize(
                    preferredSize: const Size.fromHeight(7.0), // altura da borda
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2.0, color: Color(0xFFBDB133)), // estilo e cor da borda
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: verAddComentario(),
          ),
      ],
    );
  }
}