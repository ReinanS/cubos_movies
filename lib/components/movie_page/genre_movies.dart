import 'dart:developer';

import 'package:cubos_movies/controllers/movie_controller.dart';
import 'package:cubos_movies/decorators/movies_cache_repository_decorator.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/repositories/movies/movies_repository_imp.dart';
import 'package:cubos_movies/service/dio_service_imp.dart';
import 'package:cubos_movies/widgets/movie_card_widget.dart';
import 'package:cubos_movies/widgets/centered_message.dart';
import 'package:cubos_movies/widgets/centered_progress.dart';
import 'package:flutter/material.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;
  final List<MovieGenre> genres;

  GenreMovies({
    required this.genreId,
    required this.genres,
  });

  @override
  _GenreMoviesState createState() => _GenreMoviesState();
}

class _GenreMoviesState extends State<GenreMovies> {
  final _controller = MovieController(
    MoviesCacheRepositoryDecorator(
      MoviesRepositoryImp(
        DioServiceImp(),
      ),
    ),
  );

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
    return _buildGenreMovies();
  }

  void _initScrollListener() {
    _scrollController.addListener(() async {
      if (_isInFinalPage()) {
        lastPage++;
        log(lastPage.toString());
        await _controller.fetchMoviesByGenre(
            page: lastPage, genre: widget.genreId);
        setState(() {});
      }
    });
  }

  bool _isInFinalPage() {
    return (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) &&
        (_controller.currentPage == lastPage);
  }

  Future<void> _initialize() async {
    _controller.initialize(widget.genreId);
  }

  Widget _buildGenreMovies() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller.loadingApi,
        _controller.movieErrorApi,
        _controller.moviesResponseApi,
      ]),
      builder: (_, __) {
        if (_controller.loading) {
          return CenteredProgress();
        }

        if (_controller.movieError != null || !_controller.hasMovies) {
          return CenteredMessage(message: _controller.movieError!.message!);
        }
        return _buildMovies();
      },
    );
  }

  Widget _buildMovies() {
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
      movieGenres: _controller.movieGenderPoster(movie, widget.genres),
    );
  }
}
