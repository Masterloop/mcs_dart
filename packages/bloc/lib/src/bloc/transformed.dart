import 'package:masterloop_bloc/src/bloc/base.dart';

//TransformedBloc transforming bloc of type T to type S
abstract class TransformedBloc<S, T> extends BaseBloc<S, T> {
  TransformedBloc({S initialState}) : super(initialState: initialState);
}
