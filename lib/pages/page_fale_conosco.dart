import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/redes_sociais.dart';
import '../classes/sobre_nos.dart';

Future<SobreNos> getInfos() async {
  final db = FirebaseFirestore.instance;
  int error = 0;
  SobreNos info = await db.collection('sobre_nos').get().then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data();
      return SobreNos(
          id: data['id'],
          email: data['email'],
          endereco: data['endereco'],
          telefone: data['telefone'],
          historia: data['historia'],
          redes_sociais: RedesSociais(
            facebook: data['redes_sociais']['facebook'],
            instagram: data['redes_sociais']['instagram'],
            linkedin: data['redes_sociais']['linkedin'],
            twitter: data['redes_sociais']['twitter'],
            whatsapp: data['redes_sociais']['whatsapp'],
            youtube: data['redes_sociais']['youtube'],
          )
      );
      //print('${docSnapshot.id} => ${docSnapshot.data()}');
    }
    return const SobreNos(id: 0, email: "", endereco: "endereco", telefone: "telefone", historia: "historia",
        redes_sociais: RedesSociais(
            facebook: "facebook",
            instagram: "instagram",
            linkedin: "linkedin",
            twitter: "twitter",
            whatsapp: "whatsapp",
            youtube: "youtube"
        )
    );
  },
    onError: (e) => Exception("a"),
  );
  return info;
}

class PageFaleConosto extends StatefulWidget {
  const PageFaleConosto({Key? key}) : super(key: key);

  @override
  _PageFaleConostoState createState() => _PageFaleConostoState();
}

class _PageFaleConostoState extends State<PageFaleConosto> {
  // Informações de contato
  late Future<SobreNos> infos;

  @override
  void initState() {
    super.initState();
    infos = getInfos();
  }

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
              child: FutureBuilder<SobreNos>(
                  future: infos,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 15),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                const Text(
                                  "Email: ",
                                  style: TextStyle(
                                      color: Color(0xFFBDB133),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  '${snapshot.data?.email}',
                                  style: const TextStyle(
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
                            padding: const EdgeInsets.only(left: 15, top: 15),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                const Text(
                                  "Telefone: ",
                                  style: TextStyle(
                                      color: Color(0xFFBDB133),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  '${snapshot.data?.telefone}',
                                  style: const TextStyle(
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
                            padding: const EdgeInsets.only(left: 15, top: 15),
                            child: Flex(
                              direction: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Endereço: ",
                                  style: TextStyle(
                                      color: Color(0xFFBDB133),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Flexible(
                                    child: Text(
                                      '${snapshot.data?.endereco}',
                                      style: const TextStyle(
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
                            margin: const EdgeInsets.only(top: 25),
                            padding: const EdgeInsets.all(10),
                            child: const Flexible(
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
                      );
                    }
                    else if(snapshot.hasError){
                      return Text("${snapshot.error}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      );
                    } else{
                      return const CircularProgressIndicator();
                    }
                  },
                )
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
            FutureBuilder<SobreNos>(
              future: infos,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: SizedBox(
                        height: 50,
                        child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () => launchUrl(Uri.parse('${snapshot.data?.redes_sociais.facebook}')),
                                child: const Icon(FontAwesomeIcons.facebook, color: Color(0xFFBDB133)),
                              ),
                              GestureDetector(
                                onTap: () => launchUrl(Uri.parse('${snapshot.data?.redes_sociais.youtube}')),
                                child: const Icon(FontAwesomeIcons.youtube, color: Color(0xFFBDB133)),
                              ),
                              GestureDetector(
                                onTap: () => launchUrl(Uri.parse('${snapshot.data?.redes_sociais.instagram}')),
                                child: const Icon(FontAwesomeIcons.instagram, color: Color(0xFFBDB133)),
                              ),
                              GestureDetector(
                                onTap: () => launchUrl(Uri.parse('${snapshot.data?.redes_sociais.linkedin}')),
                                child: const Icon(FontAwesomeIcons.linkedin, color: Color(0xFFBDB133)),
                              ),
                              GestureDetector(
                                onTap: () => launchUrl(Uri.parse('${snapshot.data?.redes_sociais.twitter}')),
                                child: const Icon(FontAwesomeIcons.twitter, color: Color(0xFFBDB133)),
                              ),
                              GestureDetector(
                                onTap: () => launchUrl(Uri.parse('${snapshot.data?.redes_sociais.whatsapp}')),
                                child: const Icon(FontAwesomeIcons.whatsapp, color: Color(0xFFBDB133)),
                              ),
                            ]
                        ),
                      ),
                    );
                  }
                  else if(snapshot.hasError){
                    return Text("${snapshot.error}",
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    );
                  } else{
                    return const CircularProgressIndicator();
                  }
                }
            ),
          ],
        ),
      )
    );
  }
}
