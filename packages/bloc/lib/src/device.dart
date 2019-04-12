import 'package:masterloop_core_bloc/core_bloc.dart';
import 'package:masterloop_core/core.dart' show Device, ValueGetter;
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
    ValueGetter<Future<Device>> getDevice,
    SendCommand sendCommand,
  })  : assert(mid != null),
        assert(getDevice != null),
        assert(sendCommand != null),
        _getDevice = getDevice,
        _sendCommand = sendCommand,
        super();

  Future<bool> sendCommand({
    int id,
    Iterable<Map<String, dynamic>> arguments,
    Duration expiresIn = const Duration(minutes: 5),
  }) =>
      _sendCommand(id, arguments, expiresIn);

  Future<void> refresh() => _getDevice().then((d) {
        dispatch(d);
      }).catchError(dispatchError);
}
