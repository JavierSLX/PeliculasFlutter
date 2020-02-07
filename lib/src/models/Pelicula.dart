//Clase que permite obtener una lista de instancia de peliculas
class Peliculas
{
  List<Pelicula> items = new List();

  Peliculas();

  Peliculas.fromJsonList(List<dynamic> jsonList)
  {
    if(jsonList == null)
      return;

    //Obtiene cada elemento del json
    for(var item in jsonList)
    {
      //Crea una instancia de pelicula
      final pelicula = new Pelicula.fromJsonMap(item);
      items.add(pelicula);
    }
  }
}

//Clase que permite crear una instancia Pelicula
class Pelicula 
{
  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Pelicula({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  // CTRL + ALT + DOWNARROW Genera multiples cursores
  Pelicula.fromJsonMap(Map<String, dynamic> json)
  {
    popularity = json['popularity'] / 1;
    voteCount = json['vote_count'];
    video = json['video'];
    posterPath = json['poster_path'];
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    title = json['title'];
    voteAverage = json['vote_average'] / 1;
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  getPosterImg()
  {
    if(posterPath == null)
      return "https://www.shareicon.net/data/2015/10/14/655997_image_512x512.png";
    else
      return "https://image.tmdb.org/t/p/w500$posterPath";
  }
}
