import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photo_bloc/data/hits_repository.dart';
import 'package:photo_bloc/data/model/hits.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final HitsRepository repository;

  PhotoBloc({@required this.repository}) : assert(repository != null);

  @override
  PhotoState get initialState => HitsEmpty();

  @override
  Stream<PhotoState> mapEventToState(
    PhotoEvent event,
  ) async* {
    if (event is FetchHits) {
      yield HitsLoading();
      try {
        final List<Hits> hits = await repository.fetchHits(event.type);
        yield HitsLoaded(hits: hits);
      } catch (_) {
        yield HitsError();
      }
    }
  }
}
