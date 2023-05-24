import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Produto {
  final int id;
  final String nome;
  final String imagem;
  final String descricao;
  final String descricaoDetalhada;
  final DocumentReference manual;
  final DocumentReference garantia;
  final DocumentReference firmware;
  final List<dynamic> comentarios;
  final String preco;

  const Produto({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.descricao,
    required this.descricaoDetalhada,
    required this.manual,
    required this.garantia,
    required this.firmware,
    required this.comentarios,
    required this.preco,
  });
}