import 'package:masterloop_core/masterloop_core.dart'
    show Template, ValueGetter;
import 'package:masterloop_bloc/src/bloc/bloc.dart';
import 'package:masterloop_bloc/src/bloc/list.dart';
import 'dart:async';

class TemplatesBloc extends Bloc<Iterable<Template>>
    with ListBloc<Iterable<Template>, Template> {
  @override
  final ValueGetter<Future<Iterable<Template>>> onRefresh;

  //onRefresh returns as updated list of templates
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
