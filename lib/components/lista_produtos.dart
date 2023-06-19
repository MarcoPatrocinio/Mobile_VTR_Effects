import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vtr_effects/classes/produto.dart';
import 'package:vtr_effects/pages/page_fale_conosco.dart';
import 'package:vtr_effects/pages/page_veja_mais.dart';
import 'package:vtr_effects/pages/sobre_nos.dart';

import '../classes/usuario.dart';
import '../colors/primaria.dart';


Future<List<Produto>>? getProdutos() async {
  final db = FirebaseFirestore.instance;
  List<Produto> lista = <Produto>[];
  await db.collection('produtos').orderBy('id', descending: false).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        final data = docSnapshot.data();
        lista.add(
          Produto(
              id: data['id'],
              nome: data['nome'],
              imagem: data['imagem'],
              descricao: data['descricao'],
              descricaoDetalhada: data['descricaoDetalhada'],
              manual: data['manual'],
              garantia: data['garantia'],
              firmware: data['firmware'],
              comentarios: data['comentario'],
              preco: data['valor']
          )
        );
        //print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    },
    onError: (e) => debugPrint("Error completing: $e"),
  );
  return lista;
}

Future<Usuario> getUsuario(int idUser) async {
  final db = FirebaseFirestore.instance;
  Usuario usuario = await db.collection('usuarios').where('id', isEqualTo: idUser).get().then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data();
      return Usuario(
          id: data['id'],
          email: data['email'],
          senha: data['senha'],
          produtos: data['produtos'],
          imagem: data['imagem'],
          editando: false
      );
    }
    return Usuario(id: -1, email: "email", senha: "senha", produtos: <dynamic>[], imagem: FirebaseFirestore.instance.doc("gs:/vtr-effects.appspot.com/Usuarios/proffile.webp"), editando: false);
  },
    onError: (e) => debugPrint("Error completing: $e"),
  );
  return usuario;
}



class ListaProdutos extends StatefulWidget{
  final Usuario usuario;

  const ListaProdutos({super.key, required this.usuario});

  @override
  _ListaProdutosState createState() => _ListaProdutosState(usuario);
}
class _ListaProdutosState extends State<ListaProdutos>{
  final Usuario usuario;
  late Future<List<Produto>>? futureProdutos;
  late DocumentReference auxManual;
  _ListaProdutosState(this.usuario);

  @override
  void initState() {
    super.initState();
    futureProdutos = getProdutos();
  }

  double hasProdutoOpacity(List<dynamic>? data, int? idProduto){
    if (data?.contains(idProduto) == true) {
      return 0.6;
    }
    return 1;
  }

  Widget? hasProdutoCorrect(List<dynamic>? data, int? idProduto){
    if (data?.contains(idProduto) == true) {
      return Image.asset(
        'lib/assets/overlay_comprado.png',
        width: 125,
        height: 200,
        fit: BoxFit.fitWidth,
      );
    }
    return null;
  }

  Widget verFoto(produto){
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

  void transferir(context, usuario, senha, email, produto) async {
    var db = FirebaseFirestore.instance;
    if(senha == usuario.senha){
      db.collection('usuarios').where('email', isEqualTo: email).limit(1).get().then((querySnapshot) async {
        if(querySnapshot.size > 0){
          var idDoc = querySnapshot.docs[0].id;
          var data = querySnapshot.docs[0].data();
          var produtosAtt = data['produtos'];
          if(produtosAtt.contains(produto.id)){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF04121F),
                  title: const Text('Falha ao transferir',
                    style: TextStyle(
                        color: Color(0xFFBDB133),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  content: const Text('Usuario ja possui este produto',
                    style: TextStyle(
                        color: Color(0xFFBDB133),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            );
          }
          else{
            produtosAtt.add(produto.id);
            //
            db.collection('usuarios').doc(idDoc).update({'produtos': produtosAtt});
            db.collection('usuarios').where('email', isEqualTo: usuario.email).limit(1).get().then((snap) {
              var selfIdDoc = snap.docs[0].id;
              var selfData = snap.docs[0].data();
              var selfProdutosAtt = selfData['produtos'];
              selfProdutosAtt.remove(produto.id);
              db.collection('usuarios').doc(selfIdDoc).update({'produtos': selfProdutosAtt});
              usuario.produtos = selfProdutosAtt;
              setState((){});
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF04121F),
                    title: const Text('Sucesso ao tranferir',
                      style: TextStyle(
                          color: Color(0xFFBDB133),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    content: const Text('Produto foi transferido com sucesso',
                      style: TextStyle(
                          color: Color(0xFFBDB133),
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                          foregroundColor: MaterialStateProperty.all(Colors.black),
                          textStyle: MaterialStateProperty.all(const TextStyle()),
                        ),
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            });
            Navigator.pop(context);
          }
          //
        }
        else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF04121F),
                title: const Text('Falha ao transferir',
                  style: TextStyle(
                      color: Color(0xFFBDB133),
                      fontWeight: FontWeight.bold
                  ),
                ),
                content: const Text('Email não cadastrado',
                  style: TextStyle(
                      color: Color(0xFFBDB133),
                      fontWeight: FontWeight.w500
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      textStyle: MaterialStateProperty.all(const TextStyle()),
                    ),
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      });
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF04121F),
            title: const Text('Falha ao transferir',
              style: TextStyle(
                  color: Color(0xFFBDB133),
                  fontWeight: FontWeight.bold
              ),
            ),
            content: const Text('Senha Incorreta',
              style: TextStyle(
                  color: Color(0xFFBDB133),
                  fontWeight: FontWeight.w500
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  textStyle: MaterialStateProperty.all(const TextStyle()),
                ),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

  }

  Widget renderTransferencia(context, usuario, produto){
    String email = "";
    String senha = "";
    if(usuario.produtos.contains(produto.id)){
      return ElevatedButton(
          onPressed:  () async {
            final screenHeight = MediaQuery.of(context).size.height;
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      builder: (_, controller) {
                        return Container(
                          color: const Color(0xff04121f),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5, right: 10, left: 10),
                                child: Text("Email do usuario", style: TextStyle(color: Colors.white, fontSize: 20),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: '',
                                      labelStyle: TextStyle(
                                          color: Color(0xFF000000)
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFBDB133)
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onChanged: (e) => email = e,
                                  autofocus: true,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5, right: 10, left: 10),
                                child: Text("Senha", style: TextStyle(color: Colors.white, fontSize: 20),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: '',
                                      labelStyle: TextStyle(
                                          color: Color(0xFF000000)
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFBDB133)
                                  ),
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (e) => senha = e,
                                  onFieldSubmitted: (e) => transferir(context, usuario, senha, email, produto),
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
                                    child: const Text('Confirmar'),
                                    onPressed: () => transferir(context, usuario, senha, email, produto),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }
                  );
                }
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            textStyle: MaterialStateProperty.all(const TextStyle()),
          ),
          child: const Text("Transferir")
      );
    }
    return const Text("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: FutureBuilder<List<Produto>>(
              future: futureProdutos,
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      Produto? produto = snapshot.data?[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Opacity(
                                  opacity: hasProdutoOpacity(usuario.produtos, snapshot.data?[index].id),
                                  child: verFoto(produto)
                                ),
                                hasProdutoCorrect(usuario.produtos, snapshot.data?[index].id) ?? Container(),
                              ],
                            ),
                            SizedBox(
                              width: 240,
                              height: 150,
                              child: Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${produto?.nome}',
                                    style: const TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    '${produto?.descricao}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(5),
                                        child: ElevatedButton(
                                            onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => PageVejaMais(
                                              user: usuario,
                                              produto: produto ?? Produto(
                                                  id: -1,
                                                  nome: "",
                                                  imagem: "" as DocumentReference,
                                                  descricao: "descricao",
                                                  descricaoDetalhada: "",
                                                  manual: "" as DocumentReference,
                                                  garantia: "" as DocumentReference,
                                                  firmware: "" as DocumentReference,
                                                  comentarios: [],
                                                  preco: "0.00"
                                              ),
                                            )
                                            )
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(const MaterialColor(0xFFBDB133, mapPrimaryColor)),
                                              foregroundColor: MaterialStateProperty.all(Colors.black),
                                              textStyle: MaterialStateProperty.all(const TextStyle()),
                                            ),
                                            child: const Text("Veja Mais")
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: renderTransferencia(context, usuario, produto),
                                      )],
                                  ),
                                ],
                              ),
                            ),
                            //Tentar colocar linha
                          ],
                        ),
                      );
                    },
                  );
                }
                else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
        ),
        PreferredSize(
          preferredSize: const Size.fromHeight(10.0), // altura da borda
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Color(0xFFBDB133)), // estilo e cor da borda
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: SizedBox(
              height: 50,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PageFaleConosto(user: usuario))),
                    child: const Text(
                      "Fale Conosco",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBDB133),
                          decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => PageSobreNos(user: usuario))),
                    child: const Text(
                      "Sobre nós",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBDB133),
                          decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ]
              ),
            ),
        )
      ],
    );
  }
}