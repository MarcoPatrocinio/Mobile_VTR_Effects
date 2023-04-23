import 'package:vtr_effects/components/login_form.dart';
import 'package:flutter/material.dart';

class PageLogin extends StatelessWidget{
  const PageLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
        padding: EdgeInsets.all(15),
        child: Center(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              children: [
                Container(
                  height: 150,
                  margin: EdgeInsets.all(10),
                  child: Center(child: Image(image: AssetImage('lib/assets/VTREffectsLogo.png'),)),
                ),
                SizedBox(
                    height: 450,
                    child: Center(child: LoginForm())
                )
              ],
            )
        )
    );
  }
}