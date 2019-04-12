import 'package:masterloop_core/core.dart' show Template;
import 'package:masterloop_core_bloc/core_bloc.dart';
import 'package:masterloop_core/core.dart';
import 'dart:async';

class TemplatesBloc extends Bloc<Iterable<Template>>
    with ListBloc<Iterable<Template>, Template> {
  @override
  final ValueGetter<Future<Iterable<Template>>> onRefresh;

  TemplatesBloc({
    this.onRefresh,
    Comparator<Template> comparator,
  })  : assert(onRefresh != null),
        super() {
    if (comparator != null) {
      sort(comparator);
    }
  }
}
