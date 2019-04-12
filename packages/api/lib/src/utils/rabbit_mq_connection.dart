import 'package:stomp/stomp.dart';
import 'dart:io';
import 'package:masterloop_api/src/utils/connector.dart';
import 'dart:async';

class RabbitMQConnection {
  final StompClient stompClient;

  RabbitMQConnection._({
    this.stompClient,
  }) : assert(stompClient != null);

  static Future<RabbitMQConnection> connect({
    Map<String, dynamic> connectionData,
  }) async {
    assert(connectionData != null);
    final webScoket = await _connectToWebSocket();
    final stompClient = await _connectToStomp(
      webScoket: webScoket,
      connectionData: connectionData,
    );

    return RabbitMQConnection._(
      stompClient: stompClient,
    );
  }

  Future<void> dispose() =>
      (stompClient.isDisconnected ? Future.value() : stompClient.disconnect());

  static Future<WebSocket> _connectToWebSocket() =>
      WebSocket.connect("wss://live.masterloop.net:443/ws");

  static Future<StompClient> _connectToStomp({
    WebSocket webScoket,
    Map<String, dynamic> connectionData,
  }) {
    assert(webScoket != null);
    assert(connectionData != null);

    return StompClient.connect(
      WebSocketStompConnector(webScoket),
      heartbeat: [0, 0],
      host: connectionData["VirtualHost"],
      login: connectionData["Username"],
      passcode: connectionData["Password"],
    );
  }
}
