import 'package:masterloop_core/masterloop_core.dart'
    show Template, Bloc, ListBloc, ValueGetter;
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
