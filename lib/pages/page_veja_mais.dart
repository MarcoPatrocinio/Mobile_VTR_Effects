import 'package:flutter/material.dart';
import 'package:vtr_effects/components/veja_mais.dart';

import '../classes/produto.dart';
import '../classes/usuario.dart';
import '../components/cabecalho_paginas.dart';

class PageVejaMais extends StatelessWidget{
  final Usuario user;
  final Produto produto;
  const PageVejaMais({super.key, required this.user, required this.produto});


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Color(0xFFBDB133)),
              ),
            ),
          ),
        ),
        title: CabecalhoPaginas(nomePagina: "Detalhe", user: user),
        backgroundColor: const Color(0xFF04121F),
      ),
      body: VejaMais(usuario: user, produto: produto,),
    );
  }
}