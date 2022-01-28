import 'dart:developer';

import 'package:cubos_movies/core/constant.dart';
import 'package:cubos_movies/view/widgets/movie_card_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildMovieList(),
    );
  }

  _initScrollListener() {
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (_controller.currentPage == lastPage) {
          lastPage++;
          log(lastPage.toString());
          await _controller.fetchAllMovies(page: lastPage);
          setState(() {});
        }
      }
    });
  }

  Future<void> _initialize() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchAllMovies(page: lastPage);

    setState(() {
      _controller.loading = false;
    });
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(Constant.kAppName, style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildMovieList() {
    if (_controller.loading) {
      return CenteredProgress();
    }

    if (_controller.movieError != null || !_controller.hasMovies) {
      return CenteredMessage(message: _controller.movieError!.message!);
    }

    return RefreshIndicator(
      onRefresh: _initialize,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(2.0),
        itemCount: _controller.moviesCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 2,
          childAspectRatio: 0.65,
        ),
        itemBuilder: _buildMovieCard,
      ),
    );
  }

  Widget _buildMovieCard(context, index) {
    final movie = _controller.movies[index];
    return MovieCardWidget(
      movie: movie,
    );
  }
}
