import 'package:cubos_movies/core/constant.dart';
import 'package:flutter/material.dart';
import '../widgets/centered_message.dart';
import '../widgets/centered_progress.dart';
import '../widgets/movie_card.dart';
import '../controllers/movie_controller.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final _controller = MovieController();
  final _scrollController = ScrollController();
  int lastPage = 1;

  @override
  void initState() {
    super.initState();
    _initScrollListener();
    _initialize();
  }

  _initScrollListener() {
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (_controller.currentPage == lastPage) {
          lastPage++;
          await _controller.fetchAllMovies(page: lastPage);
          setState(() {});
        }
      }
    });
  }

  _initialize() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchAllMovies(page: lastPage);

    setState(() {
      _controller.loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildMovieGrid(),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(Constant.kAppName, style: TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _initialize,
          color: Colors.black,
        ),
      ],
    );
  }

  _buildMovieGrid() {
    if (_controller.loading) {
      return CenteredProgress();
    }

    if (_controller.movieError != null) {
      return CenteredMessage(message: _controller.movieError!.message!);
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(2.0),
      itemCount: _controller.moviesCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.65,
      ),
      itemBuilder: _buildMovieCard,
    );
  }

  Widget _buildMovieCard(context, index) {
    final movie = _controller.movies[index];
    return MovieCard(
      posterPath: movie.posterPath!,
      onTap: () => print(movie.title),
    );
  }

  // _openDetailPage(movieId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MovieDetailPage(movieId),
  //     ),
  //   );
  // }
}
