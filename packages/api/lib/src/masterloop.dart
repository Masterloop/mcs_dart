import 'dart:io';
import 'package:dio/dio.dart';
import 'package:masterloop_core_api/core_api.dart';
import 'package:masterloop_api/src/templates.dart';
import 'package:masterloop_api/src/devices.dart';
import 'dart:async';

class MasterloopApi implements Api {
  static const String hostUrl = "https://api.masterloop.net";

  final String host;
  final Dio _client;

  String get token =>
      _client.options.headers["Authorization"]?.replaceRange(0, 6, "");
  void set token(String token) =>
      _client.options.headers["Authorization"] = "Bearer $token";

  String get baseUrl => _client.options.baseUrl;
  void set baseUrl(String url) => _client.options.baseUrl = url;

  Future<bool> get isConnected => _client
      .get("/api/tools/ping")
      .then((response) => true)
      .catchError((_) => false);

  DevicesApi _devices;
  DevicesApi get devices => _devices ??= DevicesApi(client: _client);

  TemplatesApi _templates;
  TemplatesApi get templates => _templates ??= TemplatesApi(client: _client);

  MasterloopApi({Dio client, this.host})
      : _client = client ??
            Dio(
              BaseOptions(
                baseUrl: host ?? hostUrl,
                connectTimeout: 30000,
                receiveTimeout: 30000,
              ),
            ),
        super();

  Future<void> connect({String username, String password}) => _client.post(
        "/token",
        options: Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded"),
        ),
        data: {
          "username": username,
          "password": password,
          "grant_type": "password",
        },
      ).then((response) => token = response.data["access_token"]);

  Future<bool> disconnect() {
    token = null;
    _devices = null;
    _templates = null;
    return Future.value(true);
  }
}
