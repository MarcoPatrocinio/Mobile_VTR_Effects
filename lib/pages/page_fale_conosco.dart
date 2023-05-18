import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class PageFaleConosto extends StatefulWidget {
  const PageFaleConosto({Key? key}) : super(key: key);

  @override
  _PageFaleConostoState createState() => _PageFaleConostoState();
}

class _PageFaleConostoState extends State<PageFaleConosto> {
  // Informações de contato
  final String email = "contato@vtreffects.com";
  final String telefone = "+55 27 99866-0610";
  final String endereco = "Faculdade UCL (Campus Manguinhos), ES-010, Km 06 - Manguinhos, Serra - ES, 29173-087, Brasil";

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
                bottom: BorderSide(width: 1.0, color: Color(0xFFBDB133)), // estilo e cor da borda
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
                'Fale Conosco',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFBDB133)
                ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF04121F),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          "Email: ",
                          style: TextStyle(
                              color: Color(0xFFBDB133),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                              color: Color(0xFFBDB133),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          "Telefone: ",
                          style: TextStyle(
                              color: Color(0xFFBDB133),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          telefone,
                          style: TextStyle(
                              color: Color(0xFFBDB133),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Endereço: ",
                          style: TextStyle(
                              color: Color(0xFFBDB133),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Flexible(
                            child: Text(
                              endereco,
                              style: TextStyle(
                                  color: Color(0xFFBDB133),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 25),
                      padding: EdgeInsets.all(10),
                      child: Flexible(
                        fit: FlexFit.loose,
                        child: Image(
                          image: AssetImage('lib/assets/Local.png'),
                          width: 65,
                          height: 180,
                        ),
                      ),
                  ),
                  //Colocar o Flutter MAP
                ],
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
                      GestureDetector(
        onTap: () => launchUrl(Uri.parse('https://www.facebook.com/vtreffects')),
        child: Icon(FontAwesomeIcons.facebook, color: Color(0xFFBDB133)),
      ),
      GestureDetector(
        onTap: () => launchUrl(Uri.parse('https://www.youtube.com/channel/UC8iMcPCRQ4hOJqsdQ5tgN7A')),
        child: Icon(FontAwesomeIcons.youtube, color: Color(0xFFBDB133)),
      ),
      GestureDetector(
        onTap: () => launchUrl(Uri.parse('https://www.instagram.com/vtreffects/')),
        child: Icon(FontAwesomeIcons.instagram, color: Color(0xFFBDB133)),
      ),
      GestureDetector(
        onTap: () => launchUrl(Uri.parse('https://www.linkedin.com/uas/login?session_redirect=%2Fcompany%2F11201246')),
        child: Icon(FontAwesomeIcons.linkedin, color: Color(0xFFBDB133)),
      ),
      GestureDetector(
        onTap: () => launchUrl(Uri.parse('https://twitter.com/vtreffects')),
        child: Icon(FontAwesomeIcons.twitter, color: Color(0xFFBDB133)),
      ),
      GestureDetector(
        onTap: () => launchUrl(Uri.parse('https://api.whatsapp.com/send/?phone=5527998660610&text&type=phone_number&app_absent=0')),
        child: Icon(FontAwesomeIcons.whatsapp, color: Color(0xFFBDB133)),
      ),
                    ]
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
