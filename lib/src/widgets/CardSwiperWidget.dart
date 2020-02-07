import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/Pelicula.dart';

//Crea un widget personalizado
class CardSwiper extends StatelessWidget {

  //Lista de tarjetas que va a mostrar
  final List<Pelicula> peliculas;

  //Inicializando en el constructor (Hace obligatorio colocar la lista)
  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {

    //Toma las medidas segun el dispositivo
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10),
      //El elemento Swiper que permite ver varias imagenes en forma de cascada
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          //Widget con border redondeados con una imagen
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              image: NetworkImage(peliculas[index].getPosterImg()),
              placeholder: AssetImage("assets/photo.jpg"),
              fit: BoxFit.cover,
            )
          );
        },
        //70% del ancho
        itemWidth: _screenSize.width * 0.6,
        //50% del alto
        itemHeight: _screenSize.height * 0.5,
        //Especifica el tipo de vista de los items
        layout: SwiperLayout.STACK,
        itemCount: peliculas.length,
      ),
    );
  }
}