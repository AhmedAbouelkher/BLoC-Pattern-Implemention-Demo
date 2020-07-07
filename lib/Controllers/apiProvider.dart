import 'dart:convert';
import 'package:bloc_pattern_implementing/Models/movieModel.dart';
import 'package:http/http.dart' as Http;

class ApiProvider {
  static const String _webSiteURL = "https://api.themoviedb.org/3/";
  Future<List<Movie>> getMovies(String url) async {
    List<Movie> _tempResponse;
    try {
      Http.Response response = await Http.get(_webSiteURL + url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body.toString());
        if (data['results'] != null) {
          _tempResponse = new List<Movie>();
          data['results'].forEach((v) {
            _tempResponse.add(new Movie.fromJson(v));
          });
          return Future(() => _tempResponse);
        }
      }
      return Future.error(null);
    } catch (e) {
      print(e);
      throw Exception("Error while getting movies data from the API");
    }
  }
}
