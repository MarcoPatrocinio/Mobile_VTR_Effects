import 'package:vtr_effects/components/login_form.dart';
import 'package:flutter/material.dart';

import '../components/cadastro_form.dart';

class PageCadastro extends StatelessWidget{
  const PageCadastro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
            child: ListView(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                Container(
                  height: 150,
                  margin: const EdgeInsets.all(10),
                  child: const Center(child: Image(image: AssetImage('lib/assets/VTREffectsLogo.png'),)),
                ),
                const SizedBox(
                    height: 450,
                    child: Center(child: CadastroForm())
                )
              ],
            )
        )
    );
  }
}