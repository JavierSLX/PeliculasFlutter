import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/homePage.dart';

// ALT + Flecha mueve la linea de codigo
// El snipper "mateapp" genera todo el codigo inicial
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Quitamos la etiqueta de debug
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
      },
    );
  }
}