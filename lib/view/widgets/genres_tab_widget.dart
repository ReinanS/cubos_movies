import 'package:cubos_movies/model/genre.dart';
import 'package:cubos_movies/view/widgets/genre_movies.dart';
import 'package:cubos_movies/view/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';

class GenresTabWidget extends StatefulWidget {
  final List<Genre> genres;

  GenresTabWidget({required this.genres});

  @override
  _GenresTabWidgetState createState() => _GenresTabWidgetState();
}

class _GenresTabWidgetState extends State<GenresTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final List<String> _tabItens = [
      widget.genres[0].name,
      widget.genres[1].name,
      widget.genres[8].name,
      widget.genres[3].name,
    ];

    final action = widget.genres.firstWhere((g) => g.id == 28);
    final adventure = widget.genres.firstWhere((g) => g.id == 12);
    final fantasy = widget.genres.firstWhere((g) => g.id == 35);
    final comedy = widget.genres.firstWhere((g) => g.id == 14);

    final tabBarviews = [
      action.id,
      adventure.id,
      fantasy.id,
      comedy.id,
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: TabBarWidget(
                controller: _tabController,
                itens: _tabItens,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: tabBarviews
                  .map((id) => GenreMovies(
                        genreId: id,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
