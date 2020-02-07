
import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:peliculas/src/models/Pelicula.dart';

class PeliculaProvider
{
  String _apikey = "500984ed868632eb7483b332482c1ded";
  String _url = "api.themoviedb.org";
  String _language = "es-ES"; 
  int _popularesPage = 0;
  bool _cargando = false;

  //Para el manejo de stream
  List<Pelicula> _populares = new List();

  //El stream contiene el broadcast ya que con este permite que muchos widgets puedan estar escuchandolo en caso de ocuparlo
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  //Insertar y escuchar el stream
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  //Para terminar el stream
  void disposeStreams()
  {
    //El signo de interrogacion significa que si se tiene un valor, lo cierre
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri uri) async
  {
    //Realiza la peticion api
    final respuesta = await http.get(uri);
    print(respuesta);

    //Obtiene el mapa del string del json
    final decodeData = json.decode(respuesta.body);

    //Convierte el mapa a la lista de peliculas
    final peliculas = new Peliculas.fromJsonList(decodeData["results"]);

    //Regresa la lista de peliculas
    return peliculas.items;
  }

  //Regresa la lista de peliculas que están en el cine
  Future<List<Pelicula>> getEnCines() async
  {
    //Construye la url de peticion
    final url = Uri.https(_url, "3/movie/now_playing", {
      'api_key': _apikey,
      'language': _language
    });

    return await _procesarRespuesta(url);
  }

  //Regresa la lista de peliculas populares
  Future<List<Pelicula>> getPopulares() async
  {
    if(_cargando) return [];

    _cargando = true;
    _popularesPage++;

    //Construye la url de la peticion
    final url = Uri.https(_url, "3/movie/popular", {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final respuesta = await _procesarRespuesta(url);

    //Coloca para que la lista vaya fluyendo por el stream
    _populares.addAll(respuesta);
    popularesSink(_populares);

    _cargando = false;
    return respuesta;
  }
}