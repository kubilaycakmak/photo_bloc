part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();
}
class FetchHits extends PhotoEvent {
  final String type;
  const FetchHits(this.type);
  @override
  List<Object> get props => [type];
}
