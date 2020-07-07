import 'package:bloc_pattern_implementing/Controllers/API_KEY.dart';
import 'package:bloc_pattern_implementing/Controllers/apiProvider.dart';
import 'package:bloc_pattern_implementing/Models/movieModel.dart';

class ApiRepository {
  String _apiKey = API.API_KEY;
  ApiProvider apiProvider = ApiProvider();
  Future<List<Movie>> getMovies() async {
    return await apiProvider.getMovies("movie/popular?api_key=$_apiKey");
  }
}
