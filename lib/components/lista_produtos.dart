import 'package:flutter/material.dart';
import 'package:vtr_effects/classes/produto.dart';

class ListaProdutos extends StatefulWidget{
  const ListaProdutos({Key? key}) : super(key: key);

  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}
class _ListaProdutosState extends State<ListaProdutos>{
  List<Produto> listaProdutos = [
    const Produto(
      nome: "NARCISO DELAY",
      imagem: "narcisodelay",
      descricao: "Descrição do Produto 1",
      preco: 1449.0,
    ),
    const Produto(
      nome: "KAILANI REVERB",
      imagem: "kailanireverb",
      descricao: "Descrição do Produto 2",
      preco: 20.0,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: listaProdutos.length,
                itemBuilder: (context, index) {
                  Produto produto = listaProdutos[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('lib/assets/${produto.imagem}.png'),
                          width: 125,
                        ),
                        Container(
                          width: 240,
                          height: 150,
                          child: Container(
                            // conteúdo do componente
                            child: Flex(
                              direction: Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  produto.nome,
                                  style: const TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  'Conheça mais sobre o ${produto.nome} '
                                      'que está impressionando o Brasil.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                                ElevatedButton(onPressed: () => debugPrint("Veja Main"), child: Text("Veja Mais")),
                              ],
                            ),
                          ),
                        ),
                        //Tentar colocar linha
                      ],
                    ),
                  );
                },
              ),
          ),
          PreferredSize(
            preferredSize: const Size.fromHeight(10.0), // altura da borda
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Color(0xFFBDB133)), // estilo e cor da borda
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Container(
                height: 50,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/faleconosco'),
                      child: Text(
                        "Fale Conosco",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBDB133),
                            decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/sobrenos'),
                      child: Text(
                        "Sobre nós",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBDB133),
                            decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                  ]
                ),
              ),
          )
        ],
      )
    );
  }
}