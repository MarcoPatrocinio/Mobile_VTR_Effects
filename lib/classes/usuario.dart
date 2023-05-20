import 'dart:ffi';

import 'package:vtr_effects/classes/produto.dart';

class Usuario {
  final int id;
  final String email;
  final String senha;
  final List<dynamic> produtos;

  const Usuario({
    required this.id,
    required this.email,
    required this.senha,
    required this.produtos,
  });
}