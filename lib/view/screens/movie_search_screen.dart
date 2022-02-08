import 'dart:async';
import 'dart:developer';

import 'package:cubos_movies/controllers/movie_controller.dart';
import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/view/utils/utils.dart';
import 'package:cubos_movies/view/widgets/movie_card_widget.dart';
import 'package:cubos_movies/view/widgets/search_bar_widget.dart';
import 'package:cubos_movies/widgets/centered_message.dart';
import 'package:cubos_movies/widgets/centered_progress.dart';
import 'package:flutter/material.dart';

class MovieSearchScreen extends StatefulWidget {
  final List<MovieGenre> genres;
  MovieSearchScreen({required this.genres});

  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final _controller = MovieController();
  List<MovieModel> movies = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    this._init();
  }

  @override
  void dispose() {
    this.debouncer?.cancel();
    super.dispose();
  }

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 500)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future<void> _init() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchAllGenres();
    await _controller.fetchMovieByName(query: query);

    setState(() {
      _controller.loading = false;
      this.movies = _controller.movies;
    });
  }

  Future<void> updateMovies(String query) async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchMovieByName(query: query);

    setState(() {
      _controller.loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
            color: AppColors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: SearchBarWidget(
                hintText: 'Pesquise filmes',
                onChanged: searchMovie,
              ),
            ),
            _buildMoviesResponse(),
          ],
        ),
      ),
    );
  }

  void searchMovie(String query) async => debounce(() async {
        await _controller.fetchMovieByName(query: query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.movies = _controller.movies;
        });
      });

  Widget _buildMoviesResponse() {
    if (_controller.loading) {
      return CenteredProgress();
    }

    // if (_controller.movieError != null ||
    //     !_controller.hasMovies ||
    //     !_controller.hasGenres) {
    //   return CenteredMessage(message: _controller.movieError!.message!);
    // }

    return Expanded(child: _buildMovies());
  }

  Widget _buildMovies() {
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCardWidget(
            movie: movie,
            movieGenres:
                _controller.movieGenderPoster(movie, _controller.genres),
          );
        });
  }
}
