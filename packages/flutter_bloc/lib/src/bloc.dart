// import 'package:flutter/widgets.dart';
// import 'package:masterloop_bloc/masterloop_bloc.dart' show BaseBloc;
// import 'package:masterloop_flutter_bloc/src/provider.dart';

// class BlocProvider<T extends BaseBloc<dynamic, dynamic>> extends Provider<T> {
//   BlocProvider({
//     Key key,
//     @required Widget child,
//     @required T bloc,
//   }) : super(
//           key: key,
//           child: child,
//           data: bloc,
//         );

//   @override
//   bool updateShouldNotify(BlocProvider oldWidget) => false;

//   static T of<T extends BaseBloc<dynamic, dynamic>>(BuildContext context) {
//     final type = _typeOf<BlocProvider<T>>();
//     final BlocProvider<T> provider =
//         context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;

//     if (provider == null) {
//       throw FlutterError(
//           'BlocProvider.of() called with a context that does not contain a Bloc of type $T.\n'
//           'No ancestor could be found starting from the context that was passed '
//           'to BlocProvider.of<$T>(). This can happen '
//           'if the context you use comes from a widget above the BlocProvider.\n'
//           'The context used was:\n'
//           '  $context');
//     }
//     return provider?.data;
//   }

//   static Type _typeOf<T>() => T;
// }
