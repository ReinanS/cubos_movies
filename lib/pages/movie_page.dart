import 'dart:developer';

import 'package:cubos_movies/core/constant.dart';
import 'package:cubos_movies/view/widgets/genres_tab_widget.dart';
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

  @override
  void initState() {
    super.initState();
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

  Future<void> _initialize() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchAllGenres();

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

    if (_controller.movieError != null || !_controller.hasGenres) {
      return CenteredMessage(message: _controller.movieError!.message!);
    }

    return GenresTabWidget(genres: _controller.genres);
  }
}
