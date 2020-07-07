import 'dart:async';
import 'package:bloc_pattern_implementing/Controllers/ApiResponse.dart';
import 'package:bloc_pattern_implementing/Controllers/Repository.dart';
import 'package:bloc_pattern_implementing/Models/movieModel.dart';

class BLoCMovie {
  ApiRepository _apiRepository;
  StreamController<ApiResponse<List<Movie>>> _streamController;
  Stream<ApiResponse<List<Movie>>> get moviesStream =>
      _streamController.stream.asBroadcastStream();
  BLoCMovie() {
    _apiRepository = ApiRepository();
    _streamController = StreamController<ApiResponse<List<Movie>>>.broadcast();
    fetchData();
  }
  fetchData() async {
    _streamController.sink.add(ApiResponse.loading("Movies are loading Now"));
    try {
      List<Movie> _movies = await _apiRepository.getMovies();
      _streamController.sink.add(ApiResponse.completed(_movies));
    } catch (e) {
      _streamController.sink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  void dispose() {
    _streamController?.close();
  }
}
