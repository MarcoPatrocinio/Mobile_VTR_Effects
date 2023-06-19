import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final int id;
  final String email;
  final String senha;
  late List<dynamic> produtos;
  final DocumentReference imagem;
  late bool editando;
  late List<dynamic> notificacoes;

  Usuario({
    required this.id,
    required this.email,
    required this.senha,
    required this.produtos,
    required this.imagem,
    required this.editando
  });
}