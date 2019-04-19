import 'package:masterloop_core/masterloop_core.dart' show Device, ValueGetter;
import 'package:masterloop_bloc/src/bloc/bloc.dart';
import 'dart:async';

typedef Future<bool> SendCommand(
  int id,
  Iterable<Map<String, dynamic>> arguments,
  Duration expiresIn,
);

class DeviceBloc extends Bloc<Device> {
  final String mid;
  final ValueGetter<Future<Device>> _getDevice;
  final SendCommand _sendCommand;

  DeviceBloc({
    this.mid,
    ValueGetter<Future<Device>> onRefresh,
    SendCommand onSendCommand,
  })  : assert(mid != null),
        assert(onRefresh != null),
        assert(onSendCommand != null),
        _getDevice = onRefresh,
        _sendCommand = onSendCommand,
        super();

  Future<bool> sendCommand({
    int id,
    Iterable<Map<String, dynamic>> arguments,
    Duration expiresIn = const Duration(minutes: 5),
  }) {
    assert(id != null);

    return _sendCommand(id, arguments, expiresIn);
  }

  Future<void> refresh() => _getDevice().then((d) {
        dispatch(d);
      }).catchError(dispatchError);
}
