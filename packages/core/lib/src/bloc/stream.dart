import 'dart:async';
import 'package:masterloop_core/src/bloc/bloc.dart';

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
