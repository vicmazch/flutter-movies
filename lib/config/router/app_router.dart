

import 'package:go_router/go_router.dart';

import 'package:sec_twelve_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            return MovieScreen( movieId: state.pathParameters['id'] ?? '', );
          },
        )

      ]
    ),
  ]
);