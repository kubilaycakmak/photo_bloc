part of 'photo_bloc.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();
}

class HitsEmpty extends PhotoState {
  @override
  List<Object> get props => null;
}

class HitsLoading extends PhotoState {
  @override
  List<Object> get props => null;
}

class HitsLoaded extends PhotoState {
  final List<Hits> hits;
  HitsLoaded({@required this.hits}) : assert(hits != null);
  @override
  List<Object> get props => [hits];
}

class HitsTypeChanging extends PhotoState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class HitsTypeChanged extends PhotoState {
  final List<Hits> latest;
  final List<Hits> popular;
  final List<Hits> upcoming;
  final String typeOfPhoto;

  HitsTypeChanged({@required this.latest, this.popular, this.upcoming, @required this.typeOfPhoto});
  @override
  List<Object> get props => [latest, popular, upcoming, typeOfPhoto];
}

class HitsError extends PhotoState {
  @override
  List<Object> get props => null;
}
