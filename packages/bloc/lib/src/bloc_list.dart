//ListBloc used for bloc which holds Lists.
//Implemented sorting and filtering for ease of use
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_bloc/src/base.dart';
import 'package:masterloop_core/masterloop_core.dart' show Predicate;

abstract class ListBloc<S> extends Bloc<ListEvent<S>, BlocState<Iterable<S>>> {
  Comparator<S> _comparator;
  Predicate<S> _tester;

  @override
  final BlocState<Iterable<S>> initialState = BlocState();

  @override
  Stream<BlocState<Iterable<S>>> get state => super.state.map((state) {
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
          data: List<S>.unmodifiable(mappedItems),
        );
      });

  @override
  Stream<BlocState<Iterable<S>>> mapEventToState(event) async* {
    if (event is SortListEvent<S>) {
      _comparator = event.comparator;

      yield BlocState(
        data: List<S>.unmodifiable(
          currentState.data,
        ),
      );
    } else if (event is FilterListEvent<S>) {
      _tester = event.tester;

      yield BlocState(
        data: List<S>.unmodifiable(
          currentState.data,
        ),
      );
    } else if (event is RefreshListEvent<S>) {
      final completer = event.completer;
      yield BlocState(
        data: await refresh(event)
            .whenComplete(completer.complete)
            .catchError(completer.completeError),
      );
    } else if (event is ResetListEvent<S>) {
      yield BlocState(
        data: null,
      );
    }
  }

  Future<Iterable<S>> refresh([RefreshListEvent event]);
}

abstract class ListEvent<S> {}

class ResetListEvent<S> implements ListEvent<S> {}

class RefreshListEvent<S> with WithCompleter implements ListEvent<S> {}

class SortListEvent<S> implements ListEvent<S> {
  final Comparator<S> comparator;

  SortListEvent({this.comparator});
}

class FilterListEvent<S> implements ListEvent<S> {
  final Predicate<S> tester;

  FilterListEvent({this.tester});
}
