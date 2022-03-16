import 'package:cubos_movies/models/movie_genre.dart';
import 'package:cubos_movies/models/movie_model.dart';
import 'package:cubos_movies/pages/movie_search_page.dart';
import 'package:cubos_movies/components/movie_page/genre_movies.dart';
import 'package:cubos_movies/widgets/search_bar_container_widget.dart';
import 'package:cubos_movies/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';

class GenresTabWidget extends StatefulWidget {
  final List<MovieGenre> genres;

  GenresTabWidget({
    required this.genres,
  });

  @override
  _GenresTabWidgetState createState() => _GenresTabWidgetState();
}

class _GenresTabWidgetState extends State<GenresTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<MovieModel> movies;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MovieGenre> _tabGenres = [
      widget.genres.firstWhere((g) => g.id! == 28),
      widget.genres.firstWhere((g) => g.id! == 12),
      widget.genres.firstWhere((g) => g.id! == 14),
      widget.genres.firstWhere((g) => g.id! == 35),
    ];

    final List<String> _tabItens = [
      _tabGenres[0].name!,
      _tabGenres[1].name!,
      _tabGenres[2].name!,
      _tabGenres[3].name!,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieSearchScreen(genres: widget.genres),
                ),
              );
            },
            child: SearchBarContainerWidget(
              hintText: 'Search Movies',
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: TabBarWidget(
              controller: _tabController,
              itens: _tabItens,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: _tabGenres
                  .map((genre) => GenreMovies(
                        genreId: genre.id!,
                        genres: widget.genres,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
