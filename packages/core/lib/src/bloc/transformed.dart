import 'package:masterloop_core/src/bloc/base.dart';

abstract class TransformedBloc<S, T> extends BaseBloc<S, T> {
  TransformedBloc({S initialState}) : super(initialState: initialState);
}
