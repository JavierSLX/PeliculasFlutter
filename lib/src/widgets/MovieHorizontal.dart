import 'package:flutter/material.dart';
import 'package:peliculas/src/models/Pelicula.dart';

//Un StatelessWidget permite estandarizar un widget ya hecho
class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;

  //Funcion callback que permite la comunicacion con otro widget
  final Function siguientePagina;

  //Constructor que requiere la lista de peliculas
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  //Page que muestra las imagenes de las peliculas de 3
  final _pageController = new PageController(
      initialPage: 1,
      viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    //Listener para escuchar los cambios y obtener la posicion en pixeles y poder realizar una accion
    _pageController.addListener((){
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200)
      {
        //Ejecuta la funcion callback que se le paso 
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.30,
      //Crea un pageview (de manera horizontal)
      child: PageView.builder(
        //Quita el efecto "magnetico" del page
        pageSnapping: false,
        //Inicia con la pagina 1 y muestra 3 imagenes a lo ancho
        controller: _pageController,
        //children: _tajetas(context)
        //Items a redenrizar
        itemCount: peliculas.length,
        itemBuilder: (context, i){
          return _tarjeta(context, peliculas[i]);
        },
      ),
    );
  }

  //Crea una tarjeta de pelicula
  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    return Container(
        margin: EdgeInsets.only(right: 15),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage("assets/photo.jpg"),
                fit: BoxFit.cover,
                height: 160,
              ),
            ),
            SizedBox(height: 5,),
            //El overflow coloca 3 puntos cuando el texto rebasa el espacio
            Text(pelicula.title, 
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
  }

  List<Widget> _tajetas(BuildContext context) {

    //Obtiene un elemento de manera individual
    return peliculas.map((pelicula){
      return Container(
        margin: EdgeInsets.only(right: 15),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage("assets/photo.jpg"),
                fit: BoxFit.cover,
                height: 160,
              ),
            ),
            SizedBox(height: 5,),
            //El overflow coloca 3 puntos cuando el texto rebasa el espacio
            Text(pelicula.title, 
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}