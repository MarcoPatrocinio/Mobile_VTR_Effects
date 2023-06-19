import 'package:flutter/material.dart';
import 'package:vtr_effects/components/lista_produtos.dart';

import '../classes/usuario.dart';
import '../components/cabecalho_paginas.dart';

class PageProdutos extends StatelessWidget{
  final Usuario user;
  const PageProdutos({super.key, required this.user});


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
        title: CabecalhoPaginas(nomePagina: "Produtos", user: user,),
        backgroundColor: const Color(0xFF04121F),
      ),
      body: ListaProdutos(usuario: user),
      );
  }
}