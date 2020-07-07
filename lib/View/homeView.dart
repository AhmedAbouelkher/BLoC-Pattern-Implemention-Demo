import 'package:bloc_pattern_implementing/BLoC/blocMovie.dart';
import 'package:bloc_pattern_implementing/Controllers/ApiResponse.dart';
import 'package:bloc_pattern_implementing/Models/movieModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BLoCMovie _bloc;
  @override
  void initState() {
    _bloc = BLoCMovie();
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        cupertino: (_, __) => CupertinoNavigationBarData(
//          brightness: Brightness.dark,
//        ),
        title: Text(
          "BLoC Pattern Movies",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _bloc.fetchData(),
          child: StreamBuilder<ApiResponse<List<Movie>>>(
            stream: _bloc.moviesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loader();
              }
              if (snapshot.hasData) {
                final snapshotData = snapshot.data;
                switch (snapshotData.status) {
                  case Status.LOADING:
                    return Loader();
                    break;
                  case Status.ERROR:
                    return Error(
                      errorMessage: snapshotData.message,
                      onRetryPressed: () => _bloc.fetchData(),
                    );
                    break;
                  case Status.COMPLETED:
                    return MoviesViewer(
                      movieList: snapshotData.data,
                    );
                    break;
                }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PlatformCircularProgressIndicator(),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;
  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _color = Theme.of(context).primaryColor;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _color,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 30),
          PlatformButton(
            color: _color,
            child: Text('Retry', style: TextStyle(color: Colors.white)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class MoviesViewer extends StatelessWidget {
  final List<Movie> movieList;

  const MoviesViewer({Key key, this.movieList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: movieList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5 / 1.8,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w342${movieList[index].posterPath}',
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }
}
