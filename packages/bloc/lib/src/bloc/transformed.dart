import 'package:masterloop_core/src/bloc/base.dart';

//TransformedBloc transforming bloc of type T to type S
abstract class TransformedBloc<S, T> extends BaseBloc<S, T> {
  TransformedBloc({S initialState}) : super(initialState: initialState);
}
