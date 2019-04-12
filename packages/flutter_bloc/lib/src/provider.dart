import 'package:flutter/widgets.dart';

class Provider<T> extends InheritedWidget {
  final T data;

  Provider({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(Provider oldWidget) => false;

  static T of<T>(BuildContext context) {
    final type = _typeOf<Provider<T>>();
    final Provider<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;

    if (provider == null) {
      throw FlutterError(
          'Provider.of() called with a context that does not contain a Bloc of type $T.\n'
          'No ancestor could be found starting from the context that was passed '
          'to Provider.of<$T>(). This can happen '
          'if the context you use comes from a widget above the Provider.\n'
          'The context used was:\n'
          '  $context');
    }
    return provider?.data;
  }

  static Type _typeOf<T>() => T;
}
