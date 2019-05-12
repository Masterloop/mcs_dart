//ListBloc used for bloc which holds Lists.
//Implemented sorting and filtering for ease of use
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart' show Predicate;

mixin ListBloc<E extends ListEvent, S> on Bloc<E, BlocState<Iterable<S>>> {
  Comparator<S> _comparator;
  Predicate<S> _tester;

  @override
  Stream<BlocState<Iterable<S>>> transform(
    Stream events,
    Stream<BlocState<Iterable<S>>> Function(E) next,
  ) =>
      super.transform(events, next).distinct().map((state) {
        if (state == null || !state.hasData || state.data.isEmpty) return state;
        final items = state.data;

        List<S> mappedItems = items.toList();
        if (_tester != null) {
          mappedItems = mappedItems.where(_tester).toList();
        }
        if (_comparator != null) {
          mappedItems.sort(_comparator);
        }

        return BlocState(
          data: mappedItems,
        );
      }).distinct();

  @override
  Stream<BlocState<Iterable<S>>> mapEventToState(event) async* {
    switch (event.runtimeType) {
      case SortListEvent:
        _comparator = (event as SortListEvent<S>).comparator;
        yield BlocState(data: List.from(currentState.data));
        break;

      case FilterListEvent:
        _tester = (event as FilterListEvent<S>).tester;
        yield BlocState(data: List.from(currentState.data));
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
