import 'package:flutter/widgets.dart';
import 'package:masterloop_core_api/core_api.dart';
import 'package:masterloop_flutter_bloc/src/provider.dart';

class ApiProvider<T extends Api> extends Provider<T> {
  ApiProvider({
    Key key,
    @required T api,
    @required Widget child,
  })  : assert(api != null),
        assert(child != null),
        super(
          key: key,
          data: api,
          child: child,
        );

  static T of<T extends Api>(BuildContext context) {
    final type = _typeOf<ApiProvider<T>>();
    final ApiProvider<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;

    if (provider == null) {
      throw FlutterError(
          'ApiProvider.of() called with a context that does not contain a Bloc of type $T.\n'
          'No ancestor could be found starting from the context that was passed '
          'to ApiProvider.of<$T>(). This can happen '
          'if the context you use comes from a widget above the ApiProvider.\n'
          'The context used was:\n'
          '  $context');
    }
    return provider?.data;
  }

  static Type _typeOf<T>() => T;
}
