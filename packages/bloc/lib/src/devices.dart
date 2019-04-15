import 'package:masterloop_core/masterloop_core.dart'
    show Device, Bloc, ListBloc, ValueGetter;
import 'dart:async';

class DevicesBloc extends Bloc<Iterable<Device>>
    with ListBloc<Iterable<Device>, Device> {
  @override
  final ValueGetter<Future<Iterable<Device>>> onRefresh;

  DevicesBloc({
    this.onRefresh,
    Comparator<Device> comparator,
  })  : assert(onRefresh != null),
        super() {
    if (comparator != null) {
      sort(comparator);
    }
  }
}
