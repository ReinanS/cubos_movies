import 'dart:developer';

import 'package:cubos_movies/controllers/genre_controller.dart';
import 'package:cubos_movies/core/constant.dart';
import 'package:cubos_movies/repositories/genres_repository_imp.dart';
import 'package:cubos_movies/service/dio_service_imp.dart';
import 'package:cubos_movies/view/widgets/genres_tab_widget.dart';
import 'package:cubos_movies/widgets/centered_message.dart';
import 'package:flutter/material.dart';
import '../widgets/centered_progress.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final _controller = GenreController(
    GenresRepositoryImp(DioServiceImp()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildMovieList(),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(Constant.kAppName, style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildMovieList() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller.loading,
        _controller.movieErrorApi,
        _controller.genresApi,
      ]),
      builder: (_, __) {
        if (_controller.loading.value) {
          return CenteredProgress();
        }

        if (_controller.movieError != null || !_controller.hasGenres) {
          return CenteredMessage(message: _controller.movieError!.message!);
        }

        return GenresTabWidget(genres: _controller.genres);
      },
    );
  }
}
