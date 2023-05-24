import 'package:flutter/material.dart';
import 'package:vtr_effects/components/lista_produtos.dart';
import 'package:vtr_effects/components/veja_mais.dart';

import '../classes/produto.dart';
import '../classes/usuario.dart';

class PageVejaMais extends StatelessWidget{
  final Usuario user;
  final Produto produto;
  const PageVejaMais({required Usuario this.user, required Produto this.produto});


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
        title: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Flexible(
              fit: FlexFit.loose,
              child: Image(
                image: AssetImage('lib/assets/VTREffectsLogo.png'),
                width: 65,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                'Detalhe',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFBDB133)
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF04121F),
      ),
      body: VejaMais(usuario: user, produto: produto,),
    );
  }
}