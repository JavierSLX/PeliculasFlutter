import 'package:flutter/material.dart';
import 'package:peliculas/src/models/Pelicula.dart';
import 'package:peliculas/src/providers/peliculasProvider.dart';

//Delegado para usarse en la implementación de la búsqueda
class DataSearch extends SearchDelegate
{
  final peliculasProvider = new PeliculaProvider();
  final peliculas = [
    "Spiderman",
    "Capitan America",
    "Aquaman",
    "Batman",
    "Shazam",
    "Ironman"
  ];
  final peliculasRecientes = [
    "Spiderman",
    "Capitan America"
  ];
  String seleccion = "";

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          //Es la variable que es capaz de obtener lo que escribe el usuario, al presionar el icono borra lo escrito
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda de la AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        //El tiempo en el que se va a animar el icono
        progress: transitionAnimation,
      ),
      onPressed: (){
        //Regresa al página original
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  /*@override
  Widget buildSuggestions(BuildContext context) {
    // Las sugerencias que aparecen cuando la persona escribe (La opcion where usa un callback que checa si la pelicula inicia con la peticion)
    final listaSugerida = (query.isEmpty) ? peliculasRecientes : peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i){
        //Regresa un tipo de listado
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          //Cuando se presiona sobre la sugerencia
          onTap: (){
            seleccion = listaSugerida[i];

            //Construye los resultados para actualizar
            showResults(context);
          },
        );
      },
    );
  }*/

  Widget buildSuggestions(BuildContext context) {
    // Las sugerencias que aparecen cuando la persona escribe 
    
    if(query.isEmpty)
      return Container();

    //Regresa un widget construido a partir de un futuro
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        //Si hay datos
        if(snapshot.hasData)
        {
          final peliculas = snapshot.data;
          //Regresa una listview
          return ListView(
            children: peliculas.map((pelicula){
              //Regresa una tarjeta
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/photo.jpg'),
                  width: 50,
                  fit: BoxFit.contain
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  //Cierra la busqueda
                  close(context, null);

                  //Manda a la pagina de detalle de la pelicula
                  pelicula.uniqueId = "";
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        }
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

}