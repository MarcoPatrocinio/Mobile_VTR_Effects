import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CabecalhoPaginas extends StatelessWidget{
  final String nomePagina;
  const CabecalhoPaginas({required String this.nomePagina});

  void logout(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
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
        GestureDetector(
          onTap: () => logout(context),
          child: const Icon(FontAwesomeIcons.arrowRightFromBracket, color: Color(0xFFBDB133)),
        ),
      ],
    );
  }
}