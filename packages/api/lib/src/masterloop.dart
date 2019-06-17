import 'dart:io';
import 'package:dio/dio.dart';
import 'package:masterloop_api/src/templates.dart';
import 'package:masterloop_api/src/devices.dart';
import 'package:masterloop_core/masterloop_core.dart' show Api;
import 'dart:async';

class MasterloopApi implements Api {
  static const String url = "https://api.masterloop.net";

  final Dio _client;

  String get token =>
      _client.options.headers["Authorization"]?.replaceRange(0, 6, "");
  void set token(String token) =>
      _client.options.headers["Authorization"] = "Bearer $token";

  String get host => _client.options.baseUrl;
  void set host(String host) => _client.options.baseUrl = host;

  Future<bool> get isConnected => _client
      .get("/api/tools/ping")
      .then((response) => true)
      .catchError((_) => false);

  TemplatesApi get templates => TemplatesApi(client: _client);

  DevicesApi get devices => DevicesApi(client: _client);

  MasterloopApi({
    Dio client,
    String token,
    String host,
  })  : _client = client ??
            Dio(
              BaseOptions(
                connectTimeout: 30000,
                receiveTimeout: 30000,
              ),
            ),
        super() {
    this.host = host ?? url;
    this.token = token;
  }

  Future<void> connect({String username, String password}) => _client.post(
        "/token",
        options: Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded"),
        ),
        data: <String, String>{
          "grant_type": "password",
          "username": username,
          "password": password,
        },
      ).then((response) => token = response.data["access_token"]);

  Future<bool> disconnect() {
    token = null;
    return Future.value(true);
  }
}
