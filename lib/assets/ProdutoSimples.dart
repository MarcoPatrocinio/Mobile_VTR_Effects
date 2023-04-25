import 'package:flutter/material.dart';

class ProdutoSimples extends StatelessWidget {
  final String texto;

  const ProdutoSimples({Key? key, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(texto);
  }
}