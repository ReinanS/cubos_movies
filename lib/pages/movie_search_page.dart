import 'dart:async';
import 'dart:developer';

import 'package:cubos_movies/controllers/movie_controller.dart';
import 'package:cubos_movies/core/app_colors.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/repositories/movies/movies_repository_imp.dart';
import 'package:cubos_movies/service/dio_service_imp.dart';
import 'package:cubos_movies/view/widgets/search_bar_widget.dart';
import 'package:cubos_movies/widgets/movie_card_widget.dart';
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
  final _controller = MovieController(MoviesRepositoryImp(DioServiceImp()));
  final _scrollController = ScrollController();

  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    this._initialize();
  }

  @override
  void dispose() {
    this.debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 1000)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future<void> _initialize() async {
    _controller.fetchMovieByName(query: query);
  }

  void searchMovie(String query) async => debounce(() async {
        _controller.fetchMovieByName(query: query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          log(_controller.moviesCount.toString());
        });
      });

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Container(
            height: 100,
            margin: EdgeInsets.only(bottom: 15),
            child: SearchBarWidget(
              hintText: 'Search Movies',
              onChanged: searchMovie,
            ),
          ),
          Expanded(child: _buildMoviesResponse()),
        ],
      ),
    );
  }

  Widget _buildMoviesResponse() {
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

        if (query == "") return Center(child: Text('Search Movies'));

        if (_controller.movieError != null && query != "") {
          return CenteredMessage(message: _controller.movieError!.message!);
        }

        return _buildMovies();
      },
    );
  }

  Widget _buildMovies() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(2.0),
      itemCount: _controller.moviesCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 5,
        childAspectRatio: 0.65,
      ),
      itemBuilder: _buildMovieCard,
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
