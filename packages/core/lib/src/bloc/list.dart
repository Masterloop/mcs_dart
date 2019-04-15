import 'dart:async';
import 'package:masterloop_core/core.dart' show ValueGetter, Test;
import 'package:masterloop_core/src/bloc/base.dart';

mixin ListBloc<T, S> on BaseBloc<T, Iterable<S>> {
  Comparator<S> _comparator;
  Test<S> _tester;
  ValueGetter<Future<T>> get onRefresh;

  Stream<Iterable<S>> get state => super.state.map((items) {
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

  Future<void> refresh() => onRefresh()
      .then((items) => dispatch(items ?? <S>[]))
      .catchError(dispatchError);

  void sort(Comparator<S> comparator) {
    _comparator = comparator;
    if (current != null) {
      dispatch(current);
    }
  }

  void filter(Test<S> tester) {
    _tester = tester;
    if (current != null) {
      dispatch(current);
    }
  }
}
