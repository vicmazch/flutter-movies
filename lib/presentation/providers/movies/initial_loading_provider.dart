

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sec_twelve_app/presentation/providers/providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {

    final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
    final step2 = ref.watch(popularMoviesProvider).isEmpty;
    final step3 = ref.watch(upcomingMoviesProvider).isEmpty;
    final step4 = ref.watch(topRatedMoviesProvider).isEmpty;
    
    return ( step1 || step2 || step3 || step4 );

});