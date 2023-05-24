import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vtr_effects/classes/produto.dart';
import 'package:vtr_effects/classes/sobre_nos.dart';
import 'package:vtr_effects/pages/page_veja_mais.dart';

import '../classes/usuario.dart';


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
    onError: (e) => print("Error completing: $e"),
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
          produtos: data['produtos']
      );
    }
    return const Usuario(id: -1, email: "email", senha: "senha", produtos: <dynamic>[]);
  },
    onError: (e) => print("Error completing: $e"),
  );
  return usuario;
}


class ListaProdutos extends StatefulWidget{
  final Usuario usuario;

  const ListaProdutos({super.key, required Usuario this.usuario});

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
                                  child: Image.network(
                                    '${snapshot.data?[index].imagem}',
                                    width: 125,
                                    height: 200,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                hasProdutoCorrect(usuario.produtos, snapshot.data?[index].id) ?? Container(),
                              ],
                            ),
                            Container(
                              width: 240,
                              height: 150,
                              child: Container(
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
                                    ElevatedButton(
                                      onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => PageVejaMais(
                                        user: usuario, produto: produto ?? Produto(
                                              id: -1,
                                              nome: "",
                                              imagem: "",
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
                                      child: const Text("Veja Mais")
                                    ),
                                  ],
                                ),
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
                    onTap: () => Navigator.pushNamed(context, '/faleconosco'),
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
                    onTap: () => Navigator.pushNamed(context, '/sobrenos'),
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