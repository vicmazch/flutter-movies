

import 'package:go_router/go_router.dart';

import 'package:sec_twelve_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        return HomeScreen(pageIndex: pageIndex,);
      },
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

    // * DEFAULT-REDIRECT
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    )
  ]
);