import 'dart:async';
import 'package:masterloop_bloc/src/bloc/base.dart';

abstract class Bloc<S> extends BaseBloc<S, S> {
  Stream<S> transform(Stream<S> stream) => stream;

  Bloc({S initialState}) : super(initialState: initialState);
}
