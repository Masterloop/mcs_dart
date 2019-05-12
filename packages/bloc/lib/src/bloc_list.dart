//ListBloc used for bloc which holds Lists.
//Implemented sorting and filtering for ease of use
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterloop_core/masterloop_core.dart' show Predicate;

mixin ListBloc<E extends ListEvent, S> on Bloc<E, Iterable<S>> {
  Comparator<S> _comparator;
  Predicate<S> _tester;

  @override
  Stream<Iterable<S>> transform(
    Stream events,
    Stream<Iterable<S>> Function(E) next,
  ) =>
      super.transform(events, next).distinct().map((items) {
        if (items == null || items.isEmpty) return items;

        List<S> mappedItems = items.toList();
        if (_tester != null) {
          mappedItems = mappedItems.where(_tester).toList();
        }
        if (_comparator != null) {
          mappedItems.sort(_comparator);
        }

        return mappedItems;
      }).distinct();

  @override
  Stream<Iterable<S>> mapEventToState(event) async* {
    switch (event.runtimeType) {
      case SortListEvent:
        _comparator = (event as SortListEvent<S>).comparator;
        yield List.from(currentState);
        break;

      case FilterListEvent:
        _tester = (event as FilterListEvent<S>).tester;
        yield List.from(currentState);
        break;
    }
  }
}

abstract class ListEvent {}

class SortListEvent<S> implements ListEvent {
  final Comparator<S> comparator;

  SortListEvent({this.comparator});
}

class FilterListEvent<S> implements ListEvent {
  final Predicate<S> tester;

  FilterListEvent({this.tester});
}
