

import 'package:sec_twelve_app/domain/entities/actor.dart';
import 'package:sec_twelve_app/infrastructure/models/moviedb/credits_response.dart';

const pathUrlImageMovieDB = 'https://image.tmdb.org/t/p/w500';
const pathImageNotFound = 'https://i.seadn.io/gae/IJpqaGRflNtIYcpzE4Y9g3Rerxnf5DQj6qL1qHqdFea8jG8P0imxVamF4Tzu-HSLD-adot6skRF_fcJncpmUymqNaNUEuELcvi5YEQ?auto=format&dpr=1&w=1000';

class ActorMapper {
  
  static Actor castToActor( Cast cast ) => Actor(
    id: cast.id, 
    name: cast.name, 
    profilePath: cast.profilePath != null ? '$pathUrlImageMovieDB${cast.profilePath}' : pathImageNotFound,
    character: cast.character
  );
}