import 'package:flutter/material.dart';

import '../components/cadastro_form.dart';

class PageCadastro extends StatelessWidget{
  const PageCadastro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFF04121F),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Image(
                      image: AssetImage('lib/assets/VTREffectsLogo.png'),
                      width: 65,
                    ),
                  ),
                  Text(
                    'Novo Cadastro',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFBDB133)
                    ),
                  ),
                ]
            )
        ),
        body: const Center(child: CadastroForm())
    );
  }
}