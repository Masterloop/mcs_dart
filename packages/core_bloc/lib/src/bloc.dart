import 'dart:async';
import 'package:masterloop_core/core.dart' show ValueGetter, Test;
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc<S, T> {
  final BehaviorSubject<S> _stateSubject = BehaviorSubject<S>();

  Stream<T> get state => transform(_stateSubject.stream);
  S get current => _stateSubject.value;
  bool get isDisposed => _stateSubject.isClosed;

  BaseBloc({S initialState}) {
    if (initialState != null) {
      dispatch(initialState);
    }
  }

  Stream<T> transform(Stream<S> stream);

  void dispatch(S state) {
    if (!_stateSubject.isClosed) {
      _stateSubject.add(state);
    }
  }

  void dispatchError(Object error, {StackTrace stackTrace}) {
    if (!_stateSubject.isClosed) {
      _stateSubject.addError(error, stackTrace);
    }
  }

  void dispose() {
    _stateSubject.close();
  }
}

abstract class Bloc<S> extends BaseBloc<S, S> {
  Stream<S> transform(Stream<S> stream) => stream;

  Bloc({S initialState}) : super(initialState: initialState);
}

abstract class TransformedBloc<S, T> extends BaseBloc<S, T> {
  TransformedBloc({S initialState}) : super(initialState: initialState);
}

abstract class StreamBloc<S> extends Bloc<S> {
  StreamSubscription _subscription;

  StreamBloc({
    Stream<S> stream,
    S initialState,
  }) : super(initialState: initialState) {
    _subscription = stream.listen(dispatch);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _subscription = null;

    super.dispose();
  }
}

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
