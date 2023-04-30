import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PageSobreNos extends StatefulWidget {
  const PageSobreNos({Key? key}) : super(key: key);

  @override
  _PageSobreNosState createState() => _PageSobreNosState();
}

class _PageSobreNosState extends State<PageSobreNos> {
  // Informações de contato
  final String texto = "O ano era 2015 e nosso fundador Ítalo se encontrava"
      " insatisfeito com sua pedaleira Zoom G1. Sonhava em desbravar o mundo"
      " dos efeitos, mas não tinha recursos financeiros para investir em um"
      " setup de pedais ou mesmo em uma nova pedaleira. Contudo, a limitação"
      " financeira não foi um empecilho para ele. Pelo contrário, diante deste"
      " cenário encontrou o ambiente perfeito para a idealização de um pedal,"
      " que de forma despretensiosa se tornaria o sonho chamado VTR EFFECTS."
      "Desde muito novo sempre observava seu pai, mesmo sem formação na área,"
      " consertando alguns equipamentos de casa. Isto o tornou apaixonado por "
      "eletrônica, fazendo com que ele buscasse uma formação técnica. Naquele "
      "ano, ele já estava no 3º período do curso técnico em eletrotécnica, e "
      "apesar de já ter passado anteriormente na cabeça dele a ideia de montar "
      "o seu próprio pedal, isso só se torna realmente possível naquele ano. "
      "E sim, foi um clássico clone do Tube Screamer TS808 em uma caixinha "
      "Hammond pintada com tinta spray. Após montar o primeiro pedal e testar "
      "junto com um amigo guitarrista, este projeto se tornou algo mágico,"
      " e a ideia de criar sua marca de pedais começou a florescer aos poucos!"
      "Após fazer mais alguns pedais clones e estudar bastante sobre este "
      "assunto, ele se deparou com um mercado brasileiro muito carente de "
      "empresas que buscassem romper paradigmas, desenvolvendo produtos "
      "realmente inovadores que suprissem as necessidades do consumidor. "
      "O que ele sempre ouvia por ai era que não se existia bons pedais de "
      "guitarra fabricados no Brasil, que um pedal estrangeiro sempre será "
      "superior, porém aquela ideia não descia para ele, que logo vislumbrou"
      " que poderia trazer algo de diferente para o mercado, e ai começou a "
      "trajetória de fundação da VTR. É bem provável que você tenha se "
      "perguntado o que significa “VTR”, já que não é uma abreviação do"
      " nome do fundador como de costume, e para entender o significado de "
      "“VTR” é preciso saber um pouquinho do local por onde tudo começou, "
      "que é a maravilhosa cidade de Vitória, a ilha que é capital do estado "
      "do Espirito Santo, Ítalo nasceu em Vitória e na época que esses fatos "
      "narrados aconteceram ele ainda morava lá, e como todo capixaba da gema, "
      "ele também é apaixonado por essa ilha, e queria criar uma marca que "
      "ajudasse a fazer sua cidade ser mais reconhecida mundo afora, pelas "
      "maravilhas que se encontra por lá, então a partir disto surgiu o nome "
      "VTR, que é uma abreviação de Vitória, e para completar uma palavra que"
      " faz jus aos produtos da empresa, e assim surgiu VTR Effects."
      "Para realmente tirar do papel a VTR, Ítalo precisava de capital "
      "financeiro, algo que ele não tinha, então entrou em cena seu professor,"
      " Denilson Machado, um engenheiro eletricista fã de punk que acompanhou"
      " todo o processo de Ítalo aprendendo a montar seus primeiros pedais,"
      " ele era quem conseguia liberar o acesso de Ítalo ao laboratório da"
      " escola e assim poder usar as ferramentas para montar seus pedais.";

  final String email = "contato@vtreffects.com";
  final String telefone = "+55 27 99866-0610";
  final String endereco =
      "Faculdade UCL (Campus Manguinhos), ES-010, Km 06 - Manguinhos, Serra - ES, 29173-087, Brasil";

  // Redes sociais
  final Map<String, String> redesSociais = {
    "linkedin": "https://www.linkedin.com/empresa",
    "youtube": "https://www.youtube.com/empresa",
    "twitter": "https://www.twitter.com/empresa",
    "facebook": "https://www.facebook.com/empresa",
    "instagram": "https://www.instagram.com/empresa",
    "whatsapp": "https://wa.me/5511999999999",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10.0), // altura da borda
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1.0,
                      color: Color(0xFFBDB133)), // estilo e cor da borda
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
              Text(
                'Sobre Nós',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFBDB133)),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF04121F),
        ),
        body: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: [
              SizedBox(
                width: 375,
                child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                decoration: const BoxDecoration(
                    color: Color(0xFFBDB133),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: const Text(
                  'Nossa Historia',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
                ),
                )
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: Text(
                  texto,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                  width: 375,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 10, top: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xFFBDB133),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: const Text(
                      'Nossa Equipe',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
                    ),
                  )
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8, // número de membros da equipe
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://vtreffects.com.br/wp-content/uploads/2022/12/Design-sem-nome-2.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                  /*Container(
                    child: Row(
                      children: [

                      ],
                    )
                  ),

                    Text(
                        'Membro ${index + 1}',
                        style: TextStyle(
                          fontSize: 26
                        ),
                    ),
                    subtitle: Text('Função do Membro ${index + 1}'),
                  )*/
                },
              ),
            ],
          ),
        )
    );
  }
}
