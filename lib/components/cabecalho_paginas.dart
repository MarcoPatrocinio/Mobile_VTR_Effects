import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vtr_effects/classes/usuario.dart';
import 'package:vtr_effects/pages/page_perfil.dart';

class CabecalhoPaginas extends StatelessWidget{
  final String nomePagina;
  final Usuario user;
  const CabecalhoPaginas({super.key, required this.nomePagina, required this.user});

  void logout(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  void goToPerfil(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PagePerfil(user: Usuario(
        id: user.id,
        email: user.email,
        senha: user.senha,
        produtos: user.produtos,
        imagem: user.imagem,
        editando: true
    ))));
  }
  Widget getOpcao (BuildContext context) {
    if(user.id == -1){
      return GestureDetector(
        onTap: () => logout(context),
        child: const Icon(FontAwesomeIcons.arrowRightFromBracket, color: Color(0xFFBDB133)),
      );
    }
    if(user.editando == true){
      return GestureDetector(
        onTap: () => logout(context),
        child: const Icon(FontAwesomeIcons.arrowRightFromBracket, color: Color(0xFFBDB133)),
      );
    }
    return GestureDetector(
      onTap: () => goToPerfil(context),
      child: const Icon(FontAwesomeIcons.gear, color: Color(0xFFBDB133)),
    );
  }

  @override
  Widget build(BuildContext context){
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Flexible(
          fit: FlexFit.loose,
          child: Image(
            image: AssetImage('lib/assets/VTREffectsLogo.png'),
            width: 65,
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            nomePagina,
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Color(0xFFBDB133)
            ),
          ),
        ),
        getOpcao(context),
      ],
    );
  }
}