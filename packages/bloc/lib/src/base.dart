import 'package:bloc/bloc.dart';
import 'package:masterloop_bloc/src/state.dart';

abstract class BaseBloc<E, S> extends Bloc<E, BlocState<S>> {
  @override
  final BlocState<S> initialState = BlocState();

  @override
  Stream<BlocState<S>> get state =>
      super.state.where((s) => s.hasData).distinct();
}
