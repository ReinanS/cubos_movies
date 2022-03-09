import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cubos_movies/widgets/tab_decoration_widget.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final TabController controller;
  final List<String> itens;

  TabBarWidget({
    required this.controller,
    required this.itens,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.white,
      labelStyle: TextStyle(color: Colors.black, fontSize: 20),
      unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 20),
      unselectedLabelColor: Color(0xFF343A40),
      indicator: BubbleTabIndicator(
        indicatorHeight: 25,
        indicatorColor: Color(0xFF00384c),
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
      ),
      tabs: itens
          .map((title) => TabDecorationWidget(
                title: title,
              ))
          .toList(),
      controller: controller,
    );
  }
}
