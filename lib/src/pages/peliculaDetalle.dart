import 'package:flutter/material.dart';
import 'package:peliculas/src/models/Actores.dart';
import 'package:peliculas/src/models/Pelicula.dart';
import 'package:peliculas/src/providers/peliculasProvider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Recibe la pelicula por medio del argumento
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          //Parecido a listview
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10,),
                _posterTitulo(context, pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _crearCasting(pelicula)
              ]
            ),
          )
        ],
      )
    );
  }

  //Agrega un appbar que permite moverse con el scroll
  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      //Lo ancho que se ve expandido
      expandedHeight: 200.0,
      floating: false,
      //Se mantiene visible siempre
      pinned: true,
      //Hace flexible el titulo de la película
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title, 
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        //Coloca de fondo la imagen de banner de la pelicula
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/loading_2.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ), 
      ),
    );
  }

  //Agrega el poster de la película
  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          //Hero se encarga de dar efecto de transicion de imagen de una pagina a otra
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //El overflow es para textos largos
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis,),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //Coloca la descripción de la película
  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //Justifica ell texto
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  //Obtiene los actores que participan en la pelicula
  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new PeliculaProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){

        if(snapshot.hasData)
          return _crearActoresPageView(snapshot.data);
        else
          return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  //Crea el PageView para los actores
  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        //Para que fluya mejor el pageview
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor)
  {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/photo.jpg'),
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            )
        ],
      ),
    );
  }
}