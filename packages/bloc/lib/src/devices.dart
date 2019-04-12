import 'package:masterloop_core/core.dart' show Device;
import 'package:masterloop_core_bloc/core_bloc.dart';
import 'package:masterloop_core/core.dart';
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
