import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vtr_effects/classes/equipe.dart';
import 'package:vtr_effects/classes/redes_sociais.dart';
import 'package:vtr_effects/classes/sobre_nos.dart';
import 'package:vtr_effects/classes/usuario.dart';

import '../components/cabecalho_paginas.dart';

Future<List<Equipe>>? getEquipe() async {
  final db = FirebaseFirestore.instance;
  List<Equipe> lista = <Equipe>[];
  await db.collection('equipe').orderBy('id', descending: false).get().then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data();
      lista.add(
          Equipe(id: data['id'], nome: data['nome'], imagem: data['imagem'], funcao: data['funcao'])
      );
      //print('${docSnapshot.id} => ${docSnapshot.data()}');
    }
  },
    onError: (e) => {
      //
    }
  );
  return lista;
}

Future<SobreNos> getInfos() async {
  final db = FirebaseFirestore.instance;
  SobreNos info = await db.collection('sobre_nos').get().then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data();
      return SobreNos(
          id: data['id'],
          email: data['email'],
          endereco: data['endereco'],
          telefone: data['telefone'],
          historia: data['historia'],
          redesSociais: RedesSociais(
            facebook: data['redes_sociais']['facebook'],
            instagram: data['redes_sociais']['instagram'],
            linkedin: data['redes_sociais']['linkedin'],
            twitter: data['redes_sociais']['twitter'],
            whatsapp: data['redes_sociais']['whatsapp'],
            youtube: data['redes_sociais']['youtube'],
          )
      );
      //print('${docSnapshot.id} => ${docSnapshot.data()}');
    }
    return const SobreNos(id: 0, email: "", endereco: "endereco", telefone: "telefone", historia: "historia",
        redesSociais: RedesSociais(
            facebook: "facebook",
            instagram: "instagram",
            linkedin: "linkedin",
            twitter: "twitter",
            whatsapp: "whatsapp",
            youtube: "youtube")
    );
  },
    onError: (e) => Exception("a"),
  );
  return info;
}

class PageSobreNos extends StatefulWidget {
  final Usuario user;
  const PageSobreNos({super.key, required this.user});

  @override
  State<PageSobreNos> createState() {
    return _PageSobreNosState();
  }
}

class _PageSobreNosState extends State<PageSobreNos> {
  late Future<List<Equipe>>? futureEquipe;
  late Future<SobreNos> infos;


  @override
  void initState() {
    super.initState();
    futureEquipe = getEquipe();
    infos = getInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10.0), // altura da borda
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1.0,
                      color: Color(0xFFBDB133)), // estilo e cor da borda
                ),
              ),
            ),
          ),
          title: CabecalhoPaginas(nomePagina: "Sobre Nos", user: widget.user,),
          backgroundColor: const Color(0xFF04121F),
        ),
        body: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: [
              SizedBox(
                width: 375,
                child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                decoration: const BoxDecoration(
                    color: Color(0xFFBDB133),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: const Text(
                  'Nossa Historia',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
                ),
                )
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: FutureBuilder<SobreNos>(
                  future: infos,
                  builder: (context, snapshot) {
                    if (snapshot.hasData){
                      return Text(
                        '${snapshot.data?.historia}',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      );
                    } else if(snapshot.hasError){
                      return Text("${snapshot.error}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      );
                    } else{
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              SizedBox(
                  width: 375,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 10, top: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xFFBDB133),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: const Text(
                      'Nossa Equipe',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
                    ),
                  )
              ),
              FutureBuilder<List<Equipe>>(
                  future: futureEquipe,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: ClipOval(
                                    child: Image.network(
                                      '${snapshot.data?[index].imagem}',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                    '${snapshot.data?[index].nome}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 25),
                                  child: Text(
                                      '${snapshot.data?[index].funcao}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                          fontWeight: FontWeight.w300
                                      )
                                  ),
                                )
                                /*Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                            '${snapshot.data?[index].nome}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            )
                                        ),
                                        Text(
                                            '${snapshot.data?[index].funcao}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            )
                                        ),
                                      ],
                                    )
                                )*/
                              ],
                            );
                          }
                      );
                    }
                    else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  }
              )
            ],
          ),
        )
    );
  }
}
