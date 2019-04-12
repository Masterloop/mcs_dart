import 'dart:io';
import 'package:stomp/impl/plugin.dart';
import 'dart:async';

class WebSocketStompConnector extends BytesStompConnector {
  final WebSocket _socket;

  WebSocketStompConnector(this._socket) {
    _socket.pingInterval = const Duration(seconds: 10);
    _socket.listen(
      (dynamic data) {
        if (data != null) {
          switch (data.runtimeType) {
            case List:
              if (data.isNotEmpty) {
                onBytes(data);
              }
              break;

            case String:
              onString(data);
              break;

            default:
              break;
          }
        }
      },
      onError: onError,
      onDone: onClose,
    );
  }

  @override
  Future close() => _socket.close();

  @override
  void writeBytes_(List<int> bytes) {
    _socket.add(bytes);
  }

  @override
  Future writeStream_(Stream<List<int>> stream) => _socket.addStream(stream);
}
