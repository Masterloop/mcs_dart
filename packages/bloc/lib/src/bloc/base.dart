import 'dart:async';
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
