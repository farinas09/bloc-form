import 'package:blocform/src/bloc/provider.dart';
import 'package:blocform/src/pages/home_page.dart';
import 'package:blocform/src/pages/login_page.dart';
import 'package:blocform/src/pages/product_page.dart';
import 'package:blocform/src/pages/signup_page.dart';
import 'package:blocform/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
 
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = new Preferences();
  await prefs.initPrefs();
  

  runApp(MyApp());
 }
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login'  : (BuildContext context) => LoginPage(),
        'home'   : (BuildContext context) => HomePage(),
        'signup' : (BuildContext context) => SignupPage(),
        'product': (BuildContext context) => ProductPage(),
      },
      theme: ThemeData(primaryColor: Colors.deepPurple),
    )
    );
    
  }
}