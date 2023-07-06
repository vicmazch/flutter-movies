import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  int getCurretIndex( BuildContext context ) {
    final String location = GoRouterState.of(context).location;
    Map<String, int> indexMap = { '/': 0, '/categories': 1, '/favorites': 2 };

    return indexMap[location] ?? 0;
  }
  void onItemTap( BuildContext context, int index ) {
    List<String> routes = ['/', '/categories', '/favorites'];

    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: getCurretIndex(context),
      elevation: 0,
      onTap: (value) => onItemTap(context, value),
      items: const [
        BottomNavigationBarItem(
          label: 'Inicio',
          icon: Icon(Icons.home_max),
        ),
        BottomNavigationBarItem(
          label: 'Categorias',
          icon: Icon(Icons.label_outline),
        ),
        BottomNavigationBarItem(
          label: 'Favoritos',
          icon: Icon(Icons.favorite_outline),
        ),
      ]
    );
  }
}